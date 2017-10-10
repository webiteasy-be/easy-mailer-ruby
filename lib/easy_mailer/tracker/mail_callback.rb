module EasyMailer
  module Tracker
    class MailCallback

      attr_accessor :mail

      def initialize(mail)
        @mail = mail
      end

      def observe
        @mail_model = EasyMailer::Tracker::Options.adapter.find_by(
            EasyMailer::Tracker::Options.message_id_attr => @mail.message_id)

        return unless @mail_model

        @mail_model.update(sent_at: Time.now) if @mail_model.respond_to?(:sent_at=) && @mail_model.sent_at.nil?
      end
    end
  end
end