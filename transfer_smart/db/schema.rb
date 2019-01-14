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

ActiveRecord::Schema.define(version: 2019_01_13_215832) do

  create_table "exchange_infos", force: :cascade do |t|
    t.integer "transfer_id"
    t.decimal "sending_ammount"
    t.decimal "receiving_ammount"
    t.string "currency_from"
    t.string "currency_to"
    t.decimal "exchange_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "personal_infos", force: :cascade do |t|
    t.integer "transfer_id"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "country"
    t.string "city"
    t.string "address"
    t.string "postal_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipient_infos", force: :cascade do |t|
    t.integer "transfer_id"
    t.string "name"
    t.string "email"
    t.string "iban"
    t.string "bank_code"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transfers", force: :cascade do |t|
    t.integer "user_id"
    t.integer "recipient_info_id"
    t.integer "personal_info_id"
    t.integer "exchange_info_id"
    t.integer "account_number"
    t.string "reference"
    t.string "bank_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "completed"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
