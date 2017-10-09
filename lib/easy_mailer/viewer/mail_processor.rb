require 'easy_mailer/core/mail_processor'
module EasyMailer
  module Viewer
    class MailProcessor < EasyMailer::Core::MailProcessor
      def process
        EasyMailer::Viewer.adapter.process(mail, options)
      end
    end
  end
end