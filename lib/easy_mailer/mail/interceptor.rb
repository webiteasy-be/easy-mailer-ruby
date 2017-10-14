require 'easy_mailer/core/mailer'

module EasyMailer
  module Mail
    class Interceptor
      def delivering_email(mail)
        if EasyMailer.feature_enabled?(:subscriber)
          EasyMailer::Subscriber::MailProcessor.new(mail).process
        end

        if EasyMailer.feature_enabled?(:tracker)
          EasyMailer::Tracker::MailProcessor.new(mail).process
        end

        if EasyMailer.feature_enabled?(:viewer)
          EasyMailer::Viewer::MailProcessor.new(mail).process
        end

        mail.perform_deliveries = false
      end
    end
  end
end