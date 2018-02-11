require 'easy_mailer/core/mail_processor'
module EasyMailer
  module Viewer
    class MailProcessor < EasyMailer::Core::MailProcessor
      def process
        EasyMailer.logger.info "EasyMailer::Viewer::MailProcessor#process options = #{options.inspect}"

        return unless options[:enabled]

        EasyMailer::Viewer.adapter.process(mail, options)
      end
    end
  end
end