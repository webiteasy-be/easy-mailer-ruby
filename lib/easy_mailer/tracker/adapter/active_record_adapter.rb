# TODO is there any cleaner way to ensure default model to be loaded from sibling "app" dir ?
require File.join(File.dirname(__FILE__), "../../../../app/models/easy_mailer/mail_model.rb")

module EasyMailer
  module Tracker
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

          [:message_id, :mailer, :model, :tos, :created_at, :sent_at , :opened_at , :clicked_at].each do |c|
            settings[:attributes][c] = c
          end
        end

        def process(mail, processor_options={})
          mail_record = settings[:model].find_or_initialize_by(_attr(:message_id) => mail.message_id)

          mail_record.assign_attributes({
                                            _attr(:mailer) => processor_options[:mailer],
                                            _attr(:model) => processor_options[:model],
                                        })

          # Optional attributes
          mail_record.send("#{_attr(:tos)}=", Array(mail.to).join(", ")) if mail_record.respond_to?("#{_attr(:tos)}=")
          mail_record.send("#{_attr(:user)}=", processor_options[:user]) if mail_record.respond_to?("#{_attr(:user)}=")
          mail_record.send("#{_attr(:subject)}=", mail.subject) if mail_record.respond_to?("#{_attr(:subject)}=")

          EasyMailer::Tracker::MailProcessor::UTM_PARAMETERS.each do |k|
            mail_record.send("#{_attr(k.to_sym)}=", processor_options[k.to_sym]) if mail_record.respond_to?("#{_attr(k.to_sym)}=")
          end

          mail_record.assign_attributes(processor_options[:mail_model_extra] || {})

          mail_record.save!
        end

        def find(message_id)
          self.settings[:model].find_by(_attr(:message_id) => message_id)
        end

        def mark_sent(message_id)
          message_model = find(message_id)
          message_model.update(_attr(:sent_at) => Time.now) if message_model.respond_to? _attr(:sent_at)
        end

        def mark_opened(message_id)
          message_model = find(message_id)
          message_model.update(_attr(:opened_at) => Time.now) if message_model.respond_to?(_attr(:opened_at)) && message_model.send(_attr(:opened_at)).nil?
        end

        def mark_visited(message_id)
          message_model = find(message_id)
          # TODO merge updates
          message_model.update(_attr(:opened_at) => Time.now) if message_model.respond_to?(_attr(:opened_at)) && message_model.send(_attr(:opened_at)).nil?
          message_model.update(_attr(:visited_at) => Time.now) if message_model.respond_to?(_attr(:visited_at)) && message_model.send(_attr(:visited_at)).nil?
        end

        def all
          self.settings[:model].all
        end

        def where(options={})
          messages_model = all

          messages_model = messages_model.where(
              self.settings[:attributes][:mailer] || :mailer => options[:mailer]) if options[:mailer]

          messages_model = messages_model.where(
              self.settings[:attributes][:model] || :model => options[:model]) if options[:model]

          # TODO there should be a Core data structure, used by every feature to represent a message (or use Mail.new())
          index = []
          messages_model.each do |m|
            index << m
          end
          index
        end

        private
        def _attr(attr)
          self.settings[:attributes][attr] || attr
        end
      end
    end
  end
end