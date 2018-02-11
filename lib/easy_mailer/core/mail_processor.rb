module EasyMailer
  module Core
    class MailProcessor

      attr_accessor :mail

      def initialize(mail)
        @mail = mail
      end

      def options
        # generate options only once
        @options ||= begin

          # Get feature from class name
          feature = self.class.name.underscore.split('/')[-2].to_sym

          mail.options_for(feature)
        end
      end

      # abstract, must be implemented
      def process
        raise "Must be implemented"
      end
    end
  end
end