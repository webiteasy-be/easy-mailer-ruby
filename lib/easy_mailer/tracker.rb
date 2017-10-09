require 'easy_mailer/tracker/mail_processor'
require 'easy_mailer/tracker/mail_callback'
require 'easy_mailer/tracker/configurator'
require 'easy_mailer/tracker/options'

module EasyMailer
  module Tracker

    class << self
      def setup
        yield(EasyMailer::Tracker::Options) if block_given?
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