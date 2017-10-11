require 'easy_mailer/core/options'

module EasyMailer
  module Viewer
    class Options < EasyMailer::Core::Options

      opt_accessor enabled: true

      def self.adapter=(*args)
        adapter_name = args.shift
        options = args.shift || {}
        adapter_name = "EasyMailer::Viewer::Adapter::#{adapter_name.to_s.camelize}Adapter"

        require adapter_name.underscore

        @adapter = adapter_name.constantize.new(options)
      end

      def self.adapter
        @adapter
      end
    end
  end
end