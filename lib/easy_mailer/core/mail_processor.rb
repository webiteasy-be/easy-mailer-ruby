module EasyMailer
  module Core
    class MailProcessor

      attr_accessor :mail

      def initialize(mail)
        @mail = mail
      end

      def options
        @options ||= begin
          feature = self.class.name.underscore.split('/')[-2].to_sym
          options = (mail.model.options_for(feature) || {}).merge(mail.options_for(feature) || {})

          options.each do |k, v|
            if v.respond_to?(:call)
              options[k] = v.call(mail)
            end
          end

          options
        end
      end

      # abstract, must be implemented
      def process
        raise "Must be implemented"
      end
    end
  end
end