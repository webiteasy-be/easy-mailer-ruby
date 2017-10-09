module EasyMailer
  class TrackerController < EasyMailer::ApplicationController

    before_action :load_mail, only: [:open, :link]

    def index
      @mail_records = EasyMailer::Tracker::Options.adapter.all
    end

    def open
      if @mail_record
        signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha1"), EasyMailer::Tracker.signature_secret, @mail_record.id)

        return render :nothing => true,
                      status: :forbidden unless secure_compare(params[:signature].to_s, signature)

        @mail_record.update!(opened_at: Time.now) unless @mail_record.opened_at
      end

      send_data Base64.decode64("R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="), type: "image/gif", disposition: "inline"
    end

    def link
      raise ActionController::RoutingError.new('Not Found') unless @mail_record.present?

      url = params[:url].to_s

      signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha1"), EasyMailer::Tracker.signature_secret, url)

      return render :nothing => true,
                    status: :forbidden unless secure_compare(params[:signature].to_s, signature)

      unless @mail_record.clicked_at
        @mail_record.clicked_at = Time.now
        @mail_record.opened_at ||= @mail_record.clicked_at
        @mail_record.save!
      end

      redirect_to url
    end

    def track_model
      @mail_records = EasyMailer::Tracker::Options.adapter.where(model: params[:model], mailer: params[:mailer])

      render 'index'
    end

    def show
      @mail_record = EasyMailer::Tracker::Options.adapter.find_by(token: params[:mail_id])

      render status: :not_found if @mail_record.nil?
    end

    private
    # from https://github.com/rails/rails/blob/master/activesupport/lib/active_support/message_verifier.rb
    # constant-time comparison algorithm to prevent timing attacks
    def secure_compare(a, b)
      return false unless a.bytesize == b.bytesize

      l = a.unpack "C#{a.bytesize}"

      res = 0
      b.each_byte { |byte| res |= byte ^ l.shift }
      res == 0
    end

    def load_mail
      # TODO check what's going on with primary_key / id of adapter !
      @mail_record = EasyMailer::Tracker::Options.adapter.find_by(EasyMailer::Tracker::Options.adapter.primary_key => params[:mail_id])
    end
  end
end
