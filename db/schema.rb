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

ActiveRecord::Schema.define(:version => 20121027212143) do

  create_table "photos", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider_type"
    t.integer  "provider_id"
    t.string   "provider_uuid"
    t.string   "badge_type"
    t.boolean  "uploaded"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "badge_file_name"
    t.string   "badge_content_type"
    t.integer  "badge_file_size"
    t.datetime "badge_updated_at"
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id",                            :null => false
    t.string   "screen_name",                        :null => false
    t.text     "message",                            :null => false
    t.string   "platform",    :default => "twitter"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "providers", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider_type",                                        :null => false
    t.string   "token",                                                :null => false
    t.string   "refresh_token"
    t.string   "secret"
    t.string   "uuid"
    t.string   "name"
    t.string   "id_str"
    t.string   "email"
    t.string   "nickname"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "location"
    t.string   "description"
    t.string   "profile_image_url"
    t.string   "profile_background_image_url"
    t.string   "phone"
    t.text     "urls"
    t.string   "gender"
    t.string   "locale"
    t.boolean  "verified",                     :default => false
    t.boolean  "active",                       :default => false
    t.boolean  "following",                    :default => false
    t.integer  "followers_count",              :default => 0
    t.integer  "friends_count",                :default => 0
    t.integer  "favourites_count",             :default => 0
    t.integer  "listed_count",                 :default => 0
    t.integer  "statuses_count",               :default => 0
    t.text     "extra"
    t.string   "badge_type",                   :default => "original"
    t.datetime "originated_at"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
  end

  create_table "users", :force => true do |t|
    t.boolean  "admin",                      :default => false
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.string   "twitter_id"
    t.string   "twitter_name"
    t.string   "twitter_screen_name"
    t.boolean  "twitter_active",             :default => false
    t.string   "twitter_oauth_token"
    t.string   "twitter_oauth_token_secret"
    t.string   "twitter_badge_style",        :default => "original", :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "badge_file_name"
    t.string   "badge_content_type"
    t.integer  "badge_file_size"
    t.datetime "badge_updated_at"
    t.integer  "twitter_followers_count",    :default => 0
    t.integer  "twitter_listed_count",       :default => 0
    t.integer  "twitter_friends_count",      :default => 0
    t.integer  "twitter_favourites_count",   :default => 0
    t.string   "i_voted_for_president"
    t.string   "i_voted_because"
    t.string   "where_i_voted_at"
    t.boolean  "pledged",                    :default => false
    t.boolean  "voted",                      :default => false
    t.string   "full_name"
    t.boolean  "show_full_name",             :default => false
    t.boolean  "follow_us",                  :default => true
  end

  add_index "users", ["twitter_badge_style"], :name => "index_users_on_twitter_badge_style"
  add_index "users", ["twitter_followers_count"], :name => "index_users_on_twitter_followers_count"

end
