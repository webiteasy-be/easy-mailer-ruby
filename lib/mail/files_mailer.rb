# frozen_string_literal: true
require 'mail/check_delivery_params'

module Mail
  
  # FileDelivery class delivers emails into multiple files based on the destination
  # address.  Each file is appended to if it already exists.
  # 
  # So if you have an email going to fred@test, bob@test, joe@anothertest, and you
  # set your location path to /path/to/mails then FileDelivery will create the directory
  # if it does not exist, and put one copy of the email in three files, called
  # by their message id
  # 
  # Make sure the path you specify with :location is writable by the Ruby process
  # running Mail.
  class FilesMailer
    if ::Mail::VERSION::STRING < '2.6.6'
      include Mail::CheckDeliveryParams
    end

    if RUBY_VERSION >= '1.9.1'
      require 'fileutils'
    else
      require 'ftools'
    end

    attr_accessor :settings

    def initialize(values)
      self.settings = {
          dir: './mails',
          path_tpl: ':mailer/:model/:recipient/:message_id',
          default_mailer: 'application_mailer',
          default_model: 'mail',
          header_mailer: 'mailer',
          header_model: 'model'
      }.merge!(values)
    end

    def deliver!(mail)
      # Use Mail::CheckDeliveryParams check method
      if ::Mail::VERSION::STRING >= '2.6.6'
        Mail::CheckDeliveryParams.check(mail)
      else
        check_delivery_params(mail)
      end

      mailer = mail.header[settings[:header_mailer]] || settings[:default_mailer]
      model = mail.header[settings[:header_model]] || settings[:default_model]

      message_id = (mail.message_id ||= ::Mail.random_tag)

      Mail::Field
      mail.destinations.uniq.each do |to|
        mail_path = ::File.join(settings[:dir], settings[:path_tpl]).to_s
                        .gsub(':mailer', mailer.to_s)
                        .gsub(':model', model.to_s)
                        .gsub(':recipient', to)
                        .gsub(':message_id', message_id)

        if ::File.respond_to?(:makedirs)
          ::File.makedirs File.dirname(mail_path)
        else
          ::FileUtils.mkdir_p File.dirname(mail_path)
        end

        ::File.open(mail_path, 'w') { |f| "#{f.write(mail.encoded)}\r\n\r\n" }
      end
    end
  end
end