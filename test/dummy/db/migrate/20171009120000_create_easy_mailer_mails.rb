class CreateEasyMailerMails < ActiveRecord::Migration[5.0]
  def change
    create_table :easy_mailer_mails, id: false do |t|
      t.string :message_id, primary_key: true
      t.string :tos, null: true
      t.integer :user_id, null: true
      t.string :user_type, null: true
      t.string :mailer, null: true
      t.string :model, null: true
      t.string :utm_medium, null: true
      t.text :message, null: true
      t.datetime "created_at", null: true
      t.datetime "sent_at", null: true
      t.datetime "opened_at", null: true
      t.datetime "clicked_at", null: true
    end
  end
end
