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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121017232016) do

  create_table "lists", :force => true do |t|
    t.integer  "user_id"
    t.integer  "slot_id"
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "slots", :force => true do |t|
    t.string   "date"
    t.string   "start_time"
    t.string   "end_time"
    t.boolean  "waiting"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "spots"
  end

  create_table "slots_users", :id => false, :force => true do |t|
    t.integer "slot_id"
    t.integer "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",                  :default => false
    t.boolean  "active",                 :default => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "confirm_code"
    t.string   "reset_token"
    t.datetime "password_reset_sent_at"
  end

end
