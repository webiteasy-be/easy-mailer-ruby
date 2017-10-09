# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171009120001) do

  create_table "easy_mailer_mails", id: false, force: :cascade do |t|
    t.string "message_id"
    t.string "tos"
    t.integer "user_id"
    t.string "user_type"
    t.string "mailer"
    t.string "model"
    t.string "utm_medium"
    t.datetime "created_at"
    t.datetime "sent_at"
    t.datetime "opened_at"
    t.datetime "clicked_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "display_name"
    t.string "email"
  end

end
