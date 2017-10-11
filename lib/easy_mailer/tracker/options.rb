require 'easy_mailer/core/options'

module EasyMailer
  module Tracker
    class Options < EasyMailer::Core::Options

      opt_accessor enabled: true,
                   open: true, click: true,
                   user: proc { |mail| mail.to.size == 1 ? ::User.where(email: mail.to.first).first : nil},
                   url_options: {}, # these options are passed to the links generated for tracking
                   utm_params: true,
                   utm_source: proc { |mail| mail.model.mailer_name },
                   utm_medium: 'email',
                   utm_term: nil,
                   utm_content: nil,
                   host: nil,
                   port: nil,
                   utm_campaign: proc { |mail| mail.model.name },
                   mail_model_extra: nil # Hash of attributes to be passed to the mail model before being saved

      # Overwrite some non-default setters / getters
      class << self
        def user_changed
          @user_changed
        end

        def user=(user)
          @user_changed = true
          @default[:user] = user
        end
      end

      def self.adapter=(*args)
        adapter_name = args.shift
        options = args.shift || {}
        adapter_name = "EasyMailer::Tracker::Adapter::#{adapter_name.to_s.camelize}Adapter"

        require adapter_name.underscore

        @adapter = adapter_name.constantize.new(options)
      end

      def self.adapter
        @adapter
      end

      def self.message_id_attr=(attr)
        @message_id_attr = attr
      end

      def self.message_id_attr
        @message_id_attr ||= :message_id
      end
    end
  end
end