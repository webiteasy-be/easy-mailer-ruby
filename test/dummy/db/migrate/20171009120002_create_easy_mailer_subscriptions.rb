class CreateEasyMailerSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :easy_mailer_subscriptions do |t|
      t.string :email, null: false
      t.string :mailer, null: false
      t.string :model, null: false
      t.timestamp :subscribed_at, null: true
      t.timestamp :unsubscribed_at, null: true
    end
  end
end
