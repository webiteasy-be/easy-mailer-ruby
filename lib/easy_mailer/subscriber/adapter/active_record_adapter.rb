# TODO is there any cleaner way to ensure default model to be loaded from sibling "app" dir ?
require File.join(File.dirname(__FILE__), "../../../../app/models/easy_mailer/subscription_model.rb")
require File.join(File.dirname(__FILE__), "../../../../app/models/easy_mailer/mail_model.rb")

module EasyMailer
  module Subscriber
    module Adapter

      class ActiveRecordAdapter

        attr_accessor :settings

        def initialize(options={})
          unless defined?(ActiveRecord)
            raise "ActiveRecord gem must be available to use ActiveRecordAdapter. Run `gem install activerecord` "
          end

          self.settings = {
              subscription_model: EasyMailer::SubscriptionModel,
              message_model: EasyMailer::MailModel,
              attributes: {}
          }.merge(options)
        end

        def bounce(message, processor_options={})
          # TODO when multiple message.to
          # TODO when message.to has a name (not just an email address)
          if settings[:subscription_model]
                 .where(_attr(:email) => message.to.first)
                 .where.not(_attr(:unsubscribed_at) => nil).any?

            model = settings[:message_model].find_or_initialize_by(_attr(:message_id) => message.message_id)
            if model && model.respond_to?(_attr(:bounced_at=))
              model.send(_attr(:bounced_at=), Time.now)
              model.save
            end

            true
          end
        end

        def unsubscribe(options)
          if options[:message_id]
            model = settings[:message_model].find_or_initialize_by(_attr(:message_id) => options[:message_id])

            if model && model.respond_to?(_attr(:unsubscribed_at=))
              model.send(_attr(:unsubscribed_at=), Time.now)
              model.save
            end
          end

          record = settings[:subscription_model].find_or_initialize_by(
              _attr(:email) => options[:email],
              _attr(:mailer) => options[:mailer],
              _attr(:model) => options[:model])

          record.assign_attributes(_attr(:unsubscribed_at) => Time.now)
          record.save
        end

        def subscribe(options)
          record = settings[:subscription_model].find_or_initialize_by(
              _attr(:email) => options[:email],
              _attr(:mailer) => options[:mailer],
              _attr(:model) => options[:model])

          record.assign_attributes(_attr(:subscribed_at) => Time.now, _attr(:unsubscribed_at) => nil)
          record.save
        end

        def subscriptions_hash(options = {})
          options[:created_before] ||= Time.now
          options[:created_after] ||= 2.months.ago

          subscriptions = settings[:subscription_model]
                              .select('date(subscribed_at) as datetime, count(*) as count')
                              .group('date(subscribed_at)')
                              .where.not(subscribed_at: nil)
                              .where('subscribed_at >= ?', options[:created_after])
                              .where('subscribed_at <= ?', options[:created_before])

          unsubscriptions = settings[:subscription_model]
                                .select('date(unsubscribed_at) as datetime, count(*) as count')
                                .group('date(unsubscribed_at)')
                                .where.not(unsubscribed_at: nil)
                                .where('unsubscribed_at >= ?', options[:created_after])
                                .where('unsubscribed_at <= ?', options[:created_before])

          subscriptions = subscriptions.where(mailer: options[:mailer]) if options[:mailer]
          subscriptions = subscriptions.where(model: options[:model]) if options[:model]

          unsubscriptions = unsubscriptions.where(mailer: options[:mailer]) if options[:mailer]
          unsubscriptions = unsubscriptions.where(model: options[:model]) if options[:model]

          @data = {}

          date_index = options[:created_after].to_date
          subscriptions.each do |subscription|
            while date_index.present? && date_index < subscription.datetime.to_date do
              @data[date_index.to_s] = [0]
              date_index += 1.day
            end

            @data[subscription.datetime.to_date.to_s] = [subscription.count]

            date_index += 1.day
          end

          while date_index < options[:created_before] do
            @data[date_index.to_s] = [0]
            date_index += 1.day
          end

          date_index = options[:created_after].to_date
          unsubscriptions.each do |unsubscription|
            while date_index.present? && date_index < unsubscription.datetime.to_date do
              @data[date_index.to_s] << 0
              date_index += 1.day
            end

            @data[unsubscription.datetime.to_date.to_s] << -unsubscription.count

            date_index += 1.day
          end

          while date_index < options[:created_before] do
            @data[date_index.to_s] << 0
            date_index += 1.day
          end

          @data
        end

        def subscriptions_array(options = {})
          options[:created_before] ||= Time.now
          options[:created_after] ||= 2.months.ago

          settings[:subscription_model].select('*')
              .select('MAX(IFNULL(unsubscribed_at,0), IFNULL(subscribed_at,0)) as datetime')
              .order('MAX(IFNULL(unsubscribed_at,0), IFNULL(subscribed_at,0)) DESC')
              .where('MAX(IFNULL(unsubscribed_at,0) , IFNULL(subscribed_at,0)) >= ?', options[:created_after])
              .where('MAX(IFNULL(unsubscribed_at,0) , IFNULL(subscribed_at,0)) <= ?', options[:created_before])
              .first(15)
        end

        def bounces_hash(options = {})
          options[:created_before] ||= Time.now
          options[:created_after] ||= 2.months.ago

          bounces = settings[:message_model]
              .select("date(#{_attr(:bounced_at)}) as datetime, count(*) as count")
              .group("date(#{_attr(:bounced_at)})")
              .where.not(_attr(:bounced_at) => nil)
              .where("#{_attr(:bounced_at)} >= ?", options[:created_after])
              .where("#{_attr(:bounced_at)} <= ?", options[:created_before])

          bounces = bounces.where(mailer: options[:mailer]) if options[:mailer]
          bounces = bounces.where(model: options[:model]) if options[:model]

          data = {}

          date_index = options[:created_after].to_date
          bounces.each do |bounce|
            while date_index.present? && date_index < bounce.datetime.to_date do
              data[date_index.to_s] = [0]
              date_index += 1.day
            end

            data[bounce.datetime.to_date.to_s] = [bounce.count]

            date_index += 1.day
          end

          while date_index < options[:created_before] do
            data[date_index.to_s] = [0]
            date_index += 1.day
          end

          data
        end

        private
        def _attr(attr)
          setter = attr[-1] == '='

          attr = attr[0..-2].to_sym if setter

          r = self.settings[:attributes][attr] || attr

          setter ? "#{r}=".to_sym : r
        end
      end
    end
  end
end