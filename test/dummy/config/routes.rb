Rails.application.routes.draw do
  mount EasyMailer::Engine => "/easy_mailer"
end
