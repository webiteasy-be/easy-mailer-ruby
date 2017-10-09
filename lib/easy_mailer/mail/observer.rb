module EasyMailer
  module Mail
    class Observer
      def delivered_email(mail)
        if EasyMailer.tracker_enabled?
          EasyMailer::Tracker::MailCallback.new(mail).observe
        end
      end
    end
  end
end