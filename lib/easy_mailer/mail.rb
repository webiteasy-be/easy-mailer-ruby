require 'mail'
require 'easy_mailer/mail/interceptor'
require 'easy_mailer/mail/observer'

module EasyMailer
  module Mail # Message ...
    def self.included(base)
      base.send :extend, ClassMethods
      base.send :include, InstanceMethods
      base.send :prepend, MonkeyMethods
    end

    module MonkeyMethods
    end

    module ClassMethods
    end

    module InstanceMethods

      def model=(model)
        @model = model
      end

      def model
        @model ||= EasyMailer::Core::Model::Default
      end

      def options_for(feature)
        self.options[feature]
      end

      def options=(options)
        @options = options
      end

      def options
        @options ||= {}
      end
    end
  end
end

::Mail::Message.send :include, EasyMailer::Mail
::Mail.register_interceptor EasyMailer::Mail::Interceptor.new
::Mail.register_observer EasyMailer::Mail::Observer.new
