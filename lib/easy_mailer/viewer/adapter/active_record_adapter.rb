# TODO is there any cleaner way to ensure default model to be loaded from sibling "app" dir ?
require File.join(File.dirname(__FILE__), "../../../../app/models/easy_mailer/mail_model.rb")

module EasyMailer
  module Viewer
    module Adapter

      class ActiveRecordAdapter

        attr_accessor :settings

        def initialize(options={})
          unless defined?(ActiveRecord)
            raise "ActiveRecord gem must be available to use ActiveRecordAdapter. Run `gem install activerecord` "
          end

          self.settings = {
              model: EasyMailer::MailModel,
              attributes: {}
          }.merge(options)
        end

        def where(options={})
          messages_model = self.settings[:model].all

          messages_model = messages_model.where(
              self.settings[:attributes][:mailer] || :mailer => options[:mailer]) if options[:mailer]

          messages_model = messages_model.where(
              self.settings[:attributes][:model] || :model => options[:model]) if options[:model]

          index = []
          messages_model.each do |m|
            index << ::Mail.read_from_string(m.send(self.settings[:attributes][:message] || :message))
          end
          index
        end

        def find(message_id)
          message_model = self.settings[:model].find_by(
              self.settings[:attributes][:message_id] || :message_id => message_id)

          ::Mail.read_from_string(message_model.send(self.settings[:attributes][:message] || :message)) if message_model
        end

        def process(mail, processor_options={})

          if EasyMailer.feature_enabled?(:tracker) &&
              EasyMailer::Tracker::Options.adapter == self.settings[:model]

            # TODO update these conditions when migrating tracker to adapter system

            # tracker is enabled + using ActiveRecord adapter + using the same model
            # => will take care about saving everything
            return
          end

          # Ensure message_id
          mail.message_id ||= ::Mail.random_tag

          message_model = self.settings[:model].new(
              self.settings[:attributes][:message_id] || :message_id => mail.message_id,
              self.settings[:attributes][:message] || :message => mail.encoded,
              self.settings[:attributes][:mailer] || :mailer => processor_options[:mailer],
              self.settings[:attributes][:model] || :model => processor_options[:model],
          )

          message_model.save
        end
      end
    end
  end
end