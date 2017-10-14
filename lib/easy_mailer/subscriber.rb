require 'easy_mailer/subscriber/mail_processor'
require 'easy_mailer/subscriber/options'

module EasyMailer
  module Subscriber

    class << self
      def setup
        if defined?(Rails)
          default_url_options = Rails.configuration.action_mailer.default_url_options || {}

          EasyMailer::Subscriber::Options.host = default_url_options[:host]
          EasyMailer::Subscriber::Options.port = default_url_options[:port]
        end

        yield(EasyMailer::Subscriber::Options) if block_given?
      end
    end

    def self.options
      EasyMailer::Subscriber::Options
    end
  end
end