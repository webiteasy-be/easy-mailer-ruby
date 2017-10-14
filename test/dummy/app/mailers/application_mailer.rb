class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def contact(email, subject, message)
    @message = message

    mail(to: 'hello@example.com', cc: email, subject: subject)
  end

  def newsletter(email, subject, message)
    @message = message

    mail(to: email, subject: subject)
  end
end
