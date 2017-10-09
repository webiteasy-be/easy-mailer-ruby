module EasyMailer
  module Tracker
    class MailCallback

      attr_accessor :mail

      def initialize(mail)
        @mail
      end

      def observe
        @mail_model = EasyMailer::Tracker::Options.adapter.where(token: @mail.message_id)

        return unless @mail_model

        @mail_model.update(sent_at: Time.now) if @mail_model.respond_to?(:sent_at=) && @mail_model.sent_at.nil?
      end
    end
  end
end