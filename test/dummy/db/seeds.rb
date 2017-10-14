User.create(display_name: 'Raphaël', email: 'raphael@example.com')
User.create(display_name: 'Apolline', email: 'raphael@example.com')
User.create(display_name: 'Céline', email: 'raphael@example.com')
User.create(display_name: 'Patrick', email: 'raphael@example.com')
User.create(display_name: 'Christine', email: 'raphael@example.com')

subscription_base = {mailer: 'application_mailer', model: 'newsletter'}
(0..40).each do |i|
  EasyMailer::SubscriptionModel.create(subscription_base.merge(email: "email_#{i}@example.com", subscribed_at: Time.now - 60*60*24*5 - rand(60*60*24*30)))
end

EasyMailer::SubscriptionModel.all.each do |subscription|
  if rand > 0.8
    subscription.update(unsubscribed_at: subscription.subscribed_at + 60*60*24*3)
  end
end

(41..50).each do |i|
  EasyMailer::SubscriptionModel.create(subscription_base.merge(email: "email_#{i}@example.com", unsubscribed_at: Time.now - 60*60*24*5 - rand(60*60*24*30)))
end
