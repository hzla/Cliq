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

ActiveRecord::Schema.define(version: 20140606230748) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["category_id"], name: "category_id_ix", using: :btree

  create_table "authorizations", force: true do |t|
    t.string   "provider",   default: "facebook"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cat_interests", force: true do |t|
    t.integer "user_id",     null: false
    t.integer "category_id", null: false
  end

  add_index "cat_interests", ["user_id", "category_id"], name: "index_cat_interests_on_user_id_and_category_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
  end

  add_index "categories", ["ancestry"], name: "index_categories_on_ancestry", using: :btree

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
    t.integer "user_id",                  null: false
    t.integer "event_id",                 null: false
    t.boolean "attended", default: false
  end

  add_index "excursions", ["user_id", "event_id"], name: "index_excursions_on_user_id_and_event_id", using: :btree

  create_table "interests", force: true do |t|
    t.integer "user_id",     null: false
    t.integer "activity_id", null: false
  end

  add_index "interests", ["user_id", "activity_id"], name: "index_interests_on_user_id_and_activity_id", using: :btree

  create_table "messages", force: true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "conversation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["user_id"], name: "msg_user_id_ix", using: :btree

  create_table "partners", force: true do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "school"
    t.string   "profile_pic_url"
    t.string   "fb_token"
    t.string   "activation"
    t.text     "bio"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.string   "sex"
    t.string   "sexual_preference", default: "hetero"
    t.boolean  "active"
  end

end
