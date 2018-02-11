require 'easy_mailer/core/mailer'

module EasyMailer
  module Mail
    class Interceptor
      def delivering_email(mail)
        mail.message_id ||= ::Mail.random_tag

        EasyMailer.logger.info "EasyMailer::Mail::Interceptor#delivering_email with id #{mail.message_id}"

        if EasyMailer.feature_enabled?(:subscriber)
          EasyMailer::Subscriber::MailProcessor.new(mail).process
        end

        if EasyMailer.feature_enabled?(:tracker)
          EasyMailer::Tracker::MailProcessor.new(mail).process
        end

        if EasyMailer.feature_enabled?(:viewer)
          EasyMailer::Viewer::MailProcessor.new(mail).process
        end
      end
    end
  end
end