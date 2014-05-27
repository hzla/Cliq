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

ActiveRecord::Schema.define(version: 20140527033932) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.string   "name"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "connections", force: true do |t|
    t.integer "user_id",         null: false
    t.integer "conversation_id", null: false
  end

  add_index "connections", ["user_id", "conversation_id"], name: "index_connections_on_user_id_and_conversation_id", using: :btree

  create_table "conversations", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "location"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "partner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "excursions", force: true do |t|
    t.integer "user_id",  null: false
    t.integer "event_id", null: false
  end

  add_index "excursions", ["user_id", "event_id"], name: "index_excursions_on_user_id_and_event_id", using: :btree

  create_table "interests", force: true do |t|
    t.integer "user_id",     null: false
    t.integer "activity_id", null: false
  end

  add_index "interests", ["user_id", "activity_id"], name: "index_interests_on_user_id_and_activity_id", using: :btree

  create_table "messages", force: true do |t|
    t.text     "body"
    t.integer  "sender_id"
    t.integer  "conversation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partners", force: true do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "school"
    t.text     "bio"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
