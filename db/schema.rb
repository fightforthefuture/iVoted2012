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

ActiveRecord::Schema.define(:version => 20121017165835) do

  create_table "posts", :force => true do |t|
    t.integer  "user_id",                            :null => false
    t.string   "screen_name",                        :null => false
    t.text     "message",                            :null => false
    t.string   "platform",    :default => "twitter"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "users", :force => true do |t|
    t.boolean  "admin",                      :default => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.string   "twitter_id"
    t.string   "twitter_name"
    t.string   "twitter_screen_name"
    t.boolean  "twitter_active",             :default => false
    t.string   "twitter_oauth_token"
    t.string   "twitter_oauth_token_secret"
    t.string   "twitter_badge_style"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "badge_file_name"
    t.string   "badge_content_type"
    t.integer  "badge_file_size"
    t.datetime "badge_updated_at"
  end

end
