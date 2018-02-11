module EasyMailer
  module Mail
    class Observer
      def delivered_email(mail)

        return unless mail.perform_deliveries

        if EasyMailer.tracker_enabled?
          EasyMailer::Tracker::MailCallback.new(mail).observe
        end
      end
    end
  end
end