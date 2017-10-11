module EasyMailer
  class TrackerController < EasyMailer::ApplicationController

    def index
      @mail_records = EasyMailer::Tracker::Options.adapter.all
    end

    def open
      signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha1"), EasyMailer::Tracker.signature_secret, params[:mail_id])

      return render :nothing => true,
                    status: :forbidden unless secure_compare(params[:signature].to_s, signature)

      EasyMailer::Tracker::Options.adapter.mark_opened(params[:mail_id])

      send_data Base64.decode64("R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="), type: "image/gif", disposition: "inline"
    end

    def link
      url = params[:url].to_s

      signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha1"), EasyMailer::Tracker.signature_secret, url)

      return render :nothing => true,
                    status: :forbidden unless secure_compare(params[:signature].to_s, signature)

      EasyMailer::Tracker::Options.adapter.mark_clicked(params[:mail_id])

      redirect_to url
    end

    def track_model
      @mail_records = EasyMailer::Tracker::Options.adapter.where(model: params[:model], mailer: params[:mailer])

      render 'index'
    end

    def show
      @mail_record = EasyMailer::Tracker::Options.adapter.find(params[:mail_id])

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
  end
end
