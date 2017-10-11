require 'easy_mailer/tracker/mail_processor'
require 'easy_mailer/tracker/mail_callback'
require 'easy_mailer/tracker/configurator'
require 'easy_mailer/tracker/options'

module EasyMailer
  module Tracker

    class << self
      def setup
        if defined?(Rails)
          default_url_options = Rails.configuration.action_mailer.default_url_options || {}

          EasyMailer::Tracker::Options.host = default_url_options[:host]
          EasyMailer::Tracker::Options.port = default_url_options[:port]
        end

        yield(EasyMailer::Tracker::Options) if block_given?

        # TODO raise error if required parameters (i.e. host) is not present
      end

      def signature_secret
        "secret" # TODO
      end
    end

    def self.options
      EasyMailer::Tracker::Options
    end
  end
end