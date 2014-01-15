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

ActiveRecord::Schema.define(:version => 20140115013610) do

  create_table "allfields", :force => true do |t|
    t.string   "field_name"
    t.integer  "view_flag"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "approvalstatuses", :force => true do |t|
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "authentications", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "status"
    t.string   "salt"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "blogposts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "campaigns", :force => true do |t|
    t.integer  "startup_id"
    t.integer  "goal_sum"
    t.integer  "raised_sum"
    t.datetime "closing_date"
    t.integer  "valuation_sum"
    t.integer  "status"
    t.float    "share"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "circles", :force => true do |t|
    t.integer  "startup_id"
    t.integer  "user_id"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "colleagues", :force => true do |t|
    t.integer  "user_id"
    t.integer  "fund_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "status"
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "idea_id"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "companydescriptions", :force => true do |t|
    t.integer  "startup_id"
    t.text     "content"
    t.integer  "allfield_id"
    t.integer  "approval_status"
    t.string   "field_status"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "companydescription_id"
    t.integer  "status"
  end

  create_table "companyupdates", :force => true do |t|
    t.integer  "startup_id"
    t.string   "title"
    t.datetime "newsdate"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "fieldstates", :force => true do |t|
    t.string   "field_status"
    t.integer  "allfield_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "followers", :force => true do |t|
    t.integer  "startup_id"
    t.integer  "user_id"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "funds", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "status"
    t.string   "hashtag"
  end

  create_table "ideas", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "startup_id"
    t.integer  "user_id"
    t.integer  "idea_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "is_protected"
    t.integer  "companydescription_id"
  end

  create_table "investors", :force => true do |t|
    t.integer  "fund_id"
    t.integer  "user_id"
    t.integer  "startup_id"
    t.integer  "status"
    t.integer  "connection_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "likes", :force => true do |t|
    t.integer  "companydescription_id"
    t.integer  "user_id"
    t.integer  "score"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "status"
    t.integer  "event_type"
    t.integer  "event_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "owners", :force => true do |t|
    t.integer  "startup_id"
    t.integer  "user_id"
    t.integer  "status"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "role",       :limit => 45
  end

  create_table "pictures", :force => true do |t|
    t.integer  "startup_id"
    t.text     "description"
    t.string   "title"
    t.integer  "status"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "startups", :force => true do |t|
    t.string   "link"
    t.string   "name"
    t.text     "pitch"
    t.integer  "status"
    t.string   "avatar"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "votes"
    t.string   "prototype_link"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.integer  "startup_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "univaffiliations", :force => true do |t|
    t.string   "title_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "userinfos", :force => true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.integer  "is_main"
    t.integer  "status"
    t.string   "category_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "idea_id"
  end

  create_table "users", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "description"
    t.integer  "authentication_id"
    t.string   "avatar"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "notification_num"
    t.boolean  "email_pref",          :default => true
  end

  create_table "votes", :force => true do |t|
    t.integer  "companydescription_id"
    t.integer  "user_id"
    t.integer  "score"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "startup_id"
  end

end
