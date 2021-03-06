# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140306200134) do

  create_table "bets", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "winner_id"
  end

  create_table "comments", force: true do |t|
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.text     "text"
    t.integer  "user_id"
    t.integer  "bet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "positions", force: true do |t|
    t.integer "user_id"
    t.integer "bet_id"
    t.boolean "admin"
    t.string  "position"
    t.string  "status"
    t.boolean "win"
    t.integer "money_earned"
    t.integer "money_lost"
  end

  create_table "users", force: true do |t|
    t.string   "email",                default: "", null: false
    t.string   "encrypted_password",   default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
