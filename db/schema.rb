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

ActiveRecord::Schema.define(version: 20150909053734) do

  create_table "box_files", force: :cascade do |t|
    t.string   "name",                    limit: 255,                 null: false
    t.integer  "parent_file_id",          limit: 4
    t.boolean  "is_directory",            limit: 1,                   null: false
    t.integer  "owner_user_id",           limit: 4,                   null: false
    t.integer  "permission",              limit: 4,     default: 420, null: false
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "attachment_file_name",    limit: 255
    t.string   "attachment_content_type", limit: 255
    t.integer  "attachment_file_size",    limit: 4
    t.datetime "attachment_updated_at"
    t.text     "directory_path",          limit: 65535
  end

  create_table "update_histories", force: :cascade do |t|
    t.string   "action",     limit: 255,   null: false
    t.text     "path",       limit: 65535, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

end
