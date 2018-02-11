module EasyMailer
  module ActionMailer
    def self.included(base)
      base.send :extend, ClassMethods
      base.send :include, InstanceMethods
      base.send :prepend, MonkeyMethods

      base.class_eval do
        class << self
          def em_mailer_options
            @em_mailer_options ||= EasyMailer::Core::OptionsHolder.new
          end
        end
      end
    end

    module MonkeyMethods
      def mail(headers = {}, &block)
        # reproduce super behaviour
        return message if @_mail_was_called && headers.blank? && !block

        _message = super

        # pass options and model to the message, to be used in processors
        _message.model = EasyMailer::Core::Model.find_or_initialize(self)
        _message.options = self.class.em_mailer_options.merge em_message_options

        # return the message, ready to be intercepted by the Interceptor
        _message
      end
    end

    module ClassMethods

      # set EasyMailer shared options to be used for every models of the
      # ActionMailer
      #
      # == Example
      #
      # class UsersMailer < ApplicationMailer
      #   easy_mailer(mailer: 'registered_users')
      # end
      #
      # == Example
      #
      # class UsersMailer < ApplicationMailer
      #   easy_mailer(:tracker, click: false, open: false)
      # end
      #
      def easy_mailer(feature = nil, **options)
        if feature
          em_mailer_options.feature_options(feature).merge! options
        else
          em_mailer_options.global_options.merge! options
        end
      end
    end

    module InstanceMethods

      def em_message_options
        @em_message_options ||= EasyMailer::Core::OptionsHolder.new
      end

      # class UsersMailer < ApplicationMailer
      #   def welcome(user_id)
      #     @user = User.find_by(id: user_id)
      #
      #     easy_mailer(model: "welcome-#{Date.today.year}")
      #     mail(to: @user.email, subject: 'welcome on my app')
      #   end
      # end
      # == Example
      #
      # class UsersMailer < ApplicationMailer
      #   def welcome(user_id)
      #     @user = User.find_by(id: user_id)
      #
      #     easy_mailer(:tracker, click: false)
      #     mail(to: @user.email, subject: 'welcome on my app')
      #   end
      # end
      def easy_mailer(feature = nil, **options)
        if feature
          em_message_options.feature_options(feature).merge! options
        else
          em_message_options.global_options.merge! options
        end
      end
    end
  end
end
