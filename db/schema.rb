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

ActiveRecord::Schema.define(version: 20140815215410) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "activity_pic"
    t.integer  "suggested_by"
    t.boolean  "has_pic",      default: false
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
    t.string   "question"
    t.string   "alt_text"
    t.string   "image_url"
    t.string   "image"
    t.integer  "popularity",  default: 0
  end

  add_index "categories", ["ancestry"], name: "index_categories_on_ancestry", using: :btree

  create_table "connections", force: true do |t|
    t.integer "user_id",                         null: false
    t.integer "conversation_id",                 null: false
    t.boolean "emailed",         default: false
  end

  add_index "connections", ["user_id", "conversation_id"], name: "index_connections_on_user_id_and_conversation_id", using: :btree

  create_table "conversations", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "connected",  default: false
    t.boolean  "initiated",  default: false
    t.integer  "event_id"
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
    t.datetime "start_date"
    t.integer  "quantity",    default: 2
    t.string   "image"
    t.string   "closed",      default: "closed"
    t.string   "event_type"
    t.boolean  "music"
    t.boolean  "discussion"
    t.boolean  "activity"
    t.boolean  "party"
    t.boolean  "food"
    t.boolean  "games"
    t.boolean  "show"
    t.boolean  "twenty_one"
    t.boolean  "paid"
  end

  create_table "excursions", force: true do |t|
    t.integer "user_id",                  null: false
    t.integer "event_id",                 null: false
    t.boolean "attended", default: false
    t.boolean "created",  default: false
    t.boolean "accepted", default: false
    t.boolean "passed",   default: false
    t.boolean "seen",     default: false
  end

  add_index "excursions", ["user_id", "event_id"], name: "index_excursions_on_user_id_and_event_id", using: :btree

  create_table "interest_suggestions", force: true do |t|
    t.string  "term"
    t.integer "popularity"
    t.string  "interest_id"
    t.string  "cat_type"
    t.integer "cat_id"
    t.integer "root_id"
    t.string  "cat_name"
  end

  create_table "interests", force: true do |t|
    t.integer "user_id",     null: false
    t.integer "activity_id", null: false
  end

  add_index "interests", ["user_id", "activity_id"], name: "index_interests_on_user_id_and_activity_id", using: :btree

  create_table "location_suggestions", force: true do |t|
    t.string   "term"
    t.integer  "popularity"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: true do |t|
    t.string "name"
    t.string "address"
    t.float  "latitude"
    t.float  "longitude"
  end

  create_table "messages", force: true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "conversation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "seen",            default: false
  end

  add_index "messages", ["user_id"], name: "msg_user_id_ix", using: :btree

  create_table "partners", force: true do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
    t.string   "mon"
    t.string   "tues"
    t.string   "wed"
    t.string   "thurs"
    t.string   "fri"
    t.string   "sat"
    t.string   "sun"
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
    t.integer  "message_count",     default: 0
    t.integer  "event_count",       default: 0
    t.integer  "invite_count",      default: 0
    t.boolean  "notify_messages",   default: true
    t.boolean  "notify_events",     default: true
    t.boolean  "notify_news",       default: true
    t.integer  "timezone"
    t.string   "role",              default: "normal"
    t.boolean  "lbgtq",             default: false
    t.text     "blacklist",         default: "0"
    t.string   "characters"
  end

end
