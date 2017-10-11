require 'easy_mailer/core/mail_processor'

module EasyMailer
  module Tracker
    class MailProcessor < EasyMailer::Core::MailProcessor

      UTM_PARAMETERS = %w(utm_source utm_medium utm_term utm_content utm_campaign)

      # Used to find closing </body> tag, to append the tracking 1x1 transparent image
      BODY_TAG_REGEX = /<\/body>/i

      def process
        if options[:enabled]
          @mail_model = EasyMailer::Tracker::Options.adapter.new

          mail.message_id ||= ::Mail.random_tag

          @mail_model.send("#{EasyMailer::Tracker::Options.message_id_attr}=", mail.message_id)

          @mail_model.tos = Array(mail.to).join(", ") if @mail_model.respond_to?(:tos=)
          @mail_model.user = options[:user]
          @mail_model.mailer = options[:mailer] if @mail_model.respond_to?(:mailer=)
          @mail_model.model = options[:model] if @mail_model.respond_to?(:model=)

          UTM_PARAMETERS.each do |k|
            @mail_model.send("#{k}=", options[k.to_sym]) if @mail_model.respond_to?("#{k}=")
          end

          @mail_model.assign_attributes(options[:mail_model_extra] || {})

          track_open if options[:open]
          track_links if options[:utm_params] || options[:click]

          @mail_model.subject = mail.subject if @mail_model.respond_to?(:subject=)
          @mail_model.message = mail.encoded if @mail_model.respond_to?(:message=)

          @mail_model.save!
        end
      end

      private
      def track_open
        if html_part
          raw_source = html_part.body.raw_source

          # Build url to the 1px tracking image
          url = url_for(
              host: options[:host],
              controller:'easy_mailer/tracker',
              action:'open',
              format: :gif,
              mail_id: @mail_model.send(EasyMailer::Tracker::Options.message_id_attr),
              signature: OpenSSL::HMAC.hexdigest(
                  OpenSSL::Digest.new("sha1"),
                  EasyMailer::Tracker.signature_secret,
                  @mail_model.id || 'nil')
          )

          pixel = ActionController::Base.helpers.image_tag(url, size: "1x1", alt: "")

          if BODY_TAG_REGEX.match?(raw_source)
            raw_source.gsub!(BODY_TAG_REGEX, "#{pixel}\n\\0")
          else
            raw_source << pixel
          end
        end
      end

      def track_links
        if html_part
          body = html_part.body

          doc = Nokogiri::HTML(body.raw_source)
          doc.css("a[href]").each do |link|
            uri = parse_uri(link['href'])

            next unless trackable?(uri)

            if options[:utm_params] && !skip_attribute?(link, "utm-params")
              params = uri.query_values(Array) || []
              UTM_PARAMETERS.each do |key|
                next if params.any? { |k, _v| k == key } || !options[key.to_sym]
                params << [key, options[key.to_sym]]
              end
              uri.query_values = params
              link['href'] = uri.to_s
            end

            if options[:click] && !skip_attribute?(link, "click")
              link['href'] =
                  url_for(
                      host: options[:host],
                      controller: 'easy_mailer/tracker',
                      action: 'link',
                      mail_id: @mail_model.send(EasyMailer::Tracker::Options.message_id_attr),
                      url: link['href'],
                      signature: OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha1"), EasyMailer::Tracker.signature_secret, link["href"])
                  )
            end
          end

          # hacky
          body.raw_source.sub!(body.raw_source, doc.to_s)
        end
      end

      def trackable?(uri)
        uri && uri.absolute? && %w(http https).include?(uri.scheme)
      end

      def skip_attribute?(link, suffix)
        attribute = "data-skip-#{suffix}"
        if link[attribute]
          # remove it
          link.remove_attribute(attribute)
          true
        elsif link["href"].to_s =~ /unsubscribe/i
          # try to avoid unsubscribe links
          true
        else
          false
        end
      end

      def html_part
        mail.html_part || (mail.content_type =~ /html/ ? mail : nil)
      end

      def url_for(opt)
        opt = (::ActionMailer::Base.default_url_options || {})
                  .merge(options[:url_options])
                  .merge(opt)

        EasyMailer::Engine.routes.url_helpers.url_for(opt)
      end

      # Parse href attribute
      # Return uri if valid, nil otherwise
      def parse_uri(href)
        # to_s prevent to return nil from this method
        Addressable::URI.parse(href.to_s) rescue nil
      end
    end
  end
end