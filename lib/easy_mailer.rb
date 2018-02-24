require 'easy_mailer/version'
require 'easy_mailer/core'
require 'easy_mailer/mail'

require 'easy_mailer/rails' if defined?(Rails)

module EasyMailer

  class << self
    attr_accessor :enabled, :allow_edit, :allow_deliver,
                  :base_controller, :mailer_args_prefix, :mail_dir, :default_mailer, :default_model

    def init!
      self.enabled            = Rails.env.production? ? false : true
      self.allow_edit         = Rails.env.production? ? false : true
      self.allow_deliver      = Rails.env.production? ? false : true
      self.default_model      = 'mail'
      self.default_mailer     = 'application_mailer'
      self.base_controller    = 'ActionController::Base'
      self.mailer_args_prefix = 'mailer_'
      self.mail_dir           = 'tmp/mails'
    end

    def logger
      if defined?(Rails)
        Rails.logger
      else
        @logger ||= Logger.new(STDOUT)
      end
    end

    def setup
      init!
      yield(self) if block_given?
    end

    def allow_update
      allow_edit && !Rails.env.production?
    end

    def feature_enabled?(feature)
      send("#{feature}_enabled?".to_sym)
    end

    def viewer_enabled?
      @viewer != nil && EasyMailer::Viewer::Options[:enabled]
    end

    def viewer
      require 'easy_mailer/viewer'

      @viewer ||= EasyMailer::Viewer
    end

    def tracker_enabled?
      @tracker != nil && EasyMailer::Tracker::Options[:enabled]
    end

    def tracker
      require 'easy_mailer/tracker'

      @tracker ||= EasyMailer::Tracker
    end

    def subscriber_enabled?
      @subscriber != nil && EasyMailer::Subscriber::Options[:enabled]
    end

    def subscriber
      require 'easy_mailer/subscriber'

      @subscriber ||= EasyMailer::Subscriber
    end
  end
end

