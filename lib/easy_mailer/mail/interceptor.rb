require 'easy_mailer/core/mailer'

module EasyMailer
  module Mail
    class Interceptor
      def delivering_email(mail)
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