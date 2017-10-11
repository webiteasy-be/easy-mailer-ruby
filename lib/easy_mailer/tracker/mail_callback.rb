module EasyMailer
  module Tracker
    class MailCallback

      attr_accessor :mail

      def initialize(mail)
        @mail = mail
      end

      def observe
        EasyMailer::Tracker::Options.adapter.mark_sent(@mail.message_id)
      end
    end
  end
end