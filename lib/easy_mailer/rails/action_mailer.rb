module EasyMailer
  module ActionMailer
    def self.included(base)
      base.send :extend, ClassMethods
      base.send :include, InstanceMethods
      base.send :prepend, MonkeyMethods

      base.class_eval do
        class << self
          def options_for(feature)
            raise "#{feature} not enabled" unless EasyMailer.feature_enabled?(feature)

            send "#{feature}_options"
          end

          def easy_mailer_options
            @easy_mailer_options ||= {}
          end

          def tracker_options
            self.easy_mailer_options[:tracker] ||= EasyMailer::Tracker::Options.new
            #@tracker_options ||= EasyMailer::Tracker::Options.new
          end

          def viewer_options
            self.easy_mailer_options[:viewer] ||= EasyMailer::Viewer::Options.new
            #@viewer_options ||= EasyMailer::Viewer::Options.new
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
        _message.options = self.easy_mailer_message_options

        # return the message, ready to be intercepted by the Interceptor
        _message
      end
    end

    module ClassMethods
      # set Tracker options to be used for every models of the ActionMailer
      #
      # == Example
      #
      # class UsersMailer < ApplicationMailer
      #   track(click: false, open: false)
      # end
      #
      # will use these two options for every models, unless overwritten
      # in the model code {@see InstanceMethod#track}
      def track(options = {})
        raise "Tracker not enabled" unless EasyMailer.tracker_enabled?

        self.tracker_options.clear
        self.tracker_options.merge!(options)
      end

      def subscribers(options = {})
        # TODO
      end
    end

    module InstanceMethods

      def easy_mailer_message_options
        @easy_mailer_message_options ||= {}
      end

      #def options_for(feature)
      #  self.class.feature_options(feature).merge( instance_variable_get("@#{feature}_options".to_sym) || {})
      #end
      #alias feature_options options_for

      # Set Tracker options to be used for the current ActionMailer action
      #
      # == Example
      #
      # class UsersMailer < ApplicationMailer
      #   def welcome(user_id)
      #     @user = User.find_by(id: user_id)
      #
      #     track(click: false)
      #     mail(to: @user.email, subject: 'welcome on my app')
      #   end
      # end
      #
      # will use these two options for every models, unless overwritten
      # in the model code {@see InstanceMethod#track}
      def track(options = {})
        raise "Tracker not enabled" unless EasyMailer.tracker_enabled?

        self.easy_mailer_message_options[:tracker] = {enabled: true}.merge(options)
        # @tracker_options = {enabled: true}.merge(options)
      end

      def subscribers(options = {})
        # TODO
      end
    end
  end
end
