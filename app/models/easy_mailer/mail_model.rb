module EasyMailer
  class MailModel < ActiveRecord::Base
    self.table_name = "easy_mailer_mails"

    belongs_to :user, polymorphic: true, optional: true
  end
end