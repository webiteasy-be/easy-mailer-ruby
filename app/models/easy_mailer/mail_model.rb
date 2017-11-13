module EasyMailer
  class MailModel < ActiveRecord::Base
    self.table_name = "easy_mailer_mails"

    if Rails.version >= '5'
      belongs_to :user, polymorphic: true, optional: true
    else
      belongs_to :user, polymorphic: true
    end
  end
end