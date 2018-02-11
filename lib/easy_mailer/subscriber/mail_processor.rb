require 'easy_mailer/core/mail_processor'
require 'mail'

module EasyMailer
  module Subscriber
    class MailProcessor < EasyMailer::Core::MailProcessor

      # Used to find closing </body> tag, to append the tracking 1x1 transparent image
      LINK_REGEX = /\{UNSUBSCRIBE_LINK\}/i

      def process
        EasyMailer.logger.info "EasyMailer::Subscriber::MailProcessor#process options = #{options.inspect}"

        return unless options[:enabled]

        if EasyMailer::Subscriber::Options.adapter.bounce(mail, options)
          mail.perform_deliveries = false
          return
        end

        replace_unsubscribe_link #if options[:open]
      end

      private
      def replace_unsubscribe_link
        if html_part
          raw_source = html_part.body.raw_source

          url = url_for(
              host: options[:host],
              port: options[:port],
              controller:'easy_mailer/subscriber',
              action:'unsubscribe',
              mailer: mail.model.mailer_name,
              model: mail.model.name,
              email: mail.to.first, # TODO what happen when multiple emails ?
              message_id: mail.message_id,
              signature: OpenSSL::HMAC.hexdigest(
                  OpenSSL::Digest.new("sha1"),
                  EasyMailer::Tracker.signature_secret,
                  mail.message_id || 'nil')
          )

          raw_source.gsub!(LINK_REGEX, url)
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
    end
  end
end