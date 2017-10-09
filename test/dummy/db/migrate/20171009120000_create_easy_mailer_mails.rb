class CreateEasyMailerMails < ActiveRecord::Migration[5.0]
  def change
    create_table :easy_mailer_mails, primary_key: :message_id, id: false do |t|
      t.string :message_id
      t.string :tos
      t.integer :user_id
      t.string :user_type
      t.string :mailer
      t.string :model
      t.string :utm_medium


      t.datetime "created_at", null: true
      t.datetime "sent_at", null: true
      t.datetime "opened_at", null: true
      t.datetime "clicked_at", null: true
    end
  end
end
