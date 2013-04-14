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

ActiveRecord::Schema.define(:version => 20130131040846) do

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "status"
    t.integer  "message_id"
    t.string   "msg_comment"
    t.string   "train_no"
    t.integer  "line"
    t.integer  "dir"
    t.integer  "s_stop"
    t.integer  "e_stop"
    t.string   "final_stop"
    t.datetime "s_time"
    t.datetime "e_time"
    t.datetime "expiry"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "activities", ["expiry"], :name => "index_activities_on_expiry"
  add_index "activities", ["user_id"], :name => "index_activities_on_user_id"

  create_table "broadcasts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "status"
    t.integer  "source"
    t.integer  "ref_msg"
    t.string   "bc_content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "invitations", :force => true do |t|
    t.integer  "sender_id"
    t.string   "recipient_email"
    t.string   "token",                                       :null => false
    t.datetime "sent_at"
    t.integer  "multiple",        :limit => 2, :default => 1
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "level_settings", :primary_key => "level", :force => true do |t|
    t.integer  "max_score"
    t.integer  "multi",                     :default => 0
    t.integer  "admin",        :limit => 2, :default => 0
    t.integer  "password",     :limit => 2, :default => 7
    t.integer  "friends",      :limit => 2, :default => 7
    t.integer  "message",      :limit => 2, :default => 0
    t.integer  "info",         :limit => 2, :default => 7
    t.integer  "login",        :limit => 2, :default => 7
    t.integer  "post",         :limit => 2, :default => 7
    t.integer  "search_mode",  :limit => 2, :default => 7
    t.integer  "nearby",       :limit => 2, :default => 7
    t.integer  "plans_value",  :limit => 2, :default => 1
    t.integer  "notify_users", :limit => 2, :default => 1
    t.integer  "invitations",  :limit => 2, :default => 10
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "mails", :force => true do |t|
    t.integer  "owner"
    t.integer  "sender"
    t.string   "subj"
    t.string   "body"
    t.string   "option"
    t.integer  "status"
    t.integer  "parent_id"
    t.string   "to_users"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.datetime "sent_date"
  end

  create_table "messages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "status"
    t.integer  "parent_id"
    t.string   "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "microposts", :force => true do |t|
    t.integer  "user_id"
    t.string   "content"
    t.string   "opt_link"
    t.integer  "message_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.datetime "expire_at"
    t.datetime "s_time"
    t.datetime "e_time"
  end

  add_index "microposts", ["user_id", "created_at"], :name => "index_microposts_on_user_id_and_created_at"

  create_table "plans", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "name",       :null => false
    t.string   "loc"
    t.string   "time"
    t.string   "subj"
    t.string   "mate"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "plans", ["user_id", "name"], :name => "index_plans_on_user_id_and_name", :unique => true

  create_table "profiles", :primary_key => "user_id", :force => true do |t|
    t.integer  "search_mode",   :limit => 2, :default => 0,  :null => false
    t.integer  "level",         :limit => 2, :default => 2,  :null => false
    t.integer  "score",                      :default => 0,  :null => false
    t.integer  "notify_users",  :limit => 2, :default => 1,  :null => false
    t.integer  "invitations",   :limit => 2, :default => 10, :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "invitation_id"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.integer  "status"
    t.string   "alias_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "relationships", ["friend_id"], :name => "index_relationships_on_friend_id"
  add_index "relationships", ["user_id", "friend_id"], :name => "index_relationships_on_user_id_and_friend_id", :unique => true
  add_index "relationships", ["user_id"], :name => "index_relationships_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "login"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "password_digest"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "remember_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["phone"], :name => "index_users_on_phone", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
