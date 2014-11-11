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

ActiveRecord::Schema.define(version: 20140807201749) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dogs", force: true do |t|
    t.integer  "user_id"
    t.string   "handle"
    t.string   "lat"
    t.string   "long"
    t.boolean  "is_active",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friends", force: true do |t|
    t.integer  "dog_id"
    t.integer  "friend_id"
    t.boolean  "is_confirmed", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "message_type"
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "read",         default: false
  end

  create_table "photos", force: true do |t|
    t.integer  "profile_id"
    t.string   "name",       limit: 100, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_name"
    t.string   "image_uid"
  end

  create_table "profiles", force: true do |t|
    t.integer  "dog_id"
    t.string   "gender"
    t.text     "photo"
    t.integer  "age"
    t.string   "breed"
    t.string   "location"
    t.string   "size"
    t.string   "personality_type"
    t.string   "humans_name"
    t.string   "fertility"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "sender"
    t.string   "receiver"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
