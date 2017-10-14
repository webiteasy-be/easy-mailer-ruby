require 'easy_mailer/core/options'

module EasyMailer
  module Subscriber
    class Options < EasyMailer::Core::Options

      opt_accessor enabled: true,
                   url_options: {}, # params to pass to the subscription url
                   host: nil,
                   port: nil

      # Overwrite some non-default setters / getters

      def self.adapter=(*args)
        adapter_name = args.shift
        options = args.shift || {}
        adapter_name = "EasyMailer::Subscriber::Adapter::#{adapter_name.to_s.camelize}Adapter"

        require adapter_name.underscore

        @adapter = adapter_name.constantize.new(options)
      end

      def self.adapter
        @adapter
      end
    end
  end
end