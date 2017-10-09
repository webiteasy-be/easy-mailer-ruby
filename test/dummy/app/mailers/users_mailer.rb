class UsersMailer < ApplicationMailer
  def welcome(user_id)
    @user = User.find_by(id: user_id)

    email_with_name = %("#{@user.display_name}" <#{@user.email}>)
    mail(to: email_with_name, subject: 'welcome on EasyMailer')
  end
end
