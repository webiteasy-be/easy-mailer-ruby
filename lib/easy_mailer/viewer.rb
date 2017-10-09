require 'easy_mailer/viewer/mail_processor'
require 'easy_mailer/viewer/options'

module EasyMailer
  module Viewer

    class << self
      def setup
        yield(self.options) if block_given?
      end
    end

    def self.options
      EasyMailer::Viewer::Options
    end

    def self.adapter
      EasyMailer::Viewer::Options.adapter
    end
  end
end