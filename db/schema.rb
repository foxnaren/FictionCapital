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

ActiveRecord::Schema.define(version: 20151101021534) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chapters", force: :cascade do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "lightnovel_id",  null: false
    t.string   "chapter_name",   null: false
    t.integer  "chapter_number", null: false
    t.string   "chapter_url",    null: false
    t.string   "raws_url"
  end

  add_index "chapters", ["lightnovel_id", "chapter_number"], name: "index_chapters_on_lightnovel_id_and_chapter_number", unique: true, using: :btree
  add_index "chapters", ["lightnovel_id"], name: "index_chapters_on_lightnovel_id", using: :btree

  create_table "examples", force: :cascade do |t|
    t.string   "name"
    t.string   "integer"
    t.string   "desc"
    t.string   "string"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lightnovels", force: :cascade do |t|
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.string   "name",                                                  null: false
    t.string   "description",                                           null: false
    t.string   "home_url",                                              null: false
    t.boolean  "is_translated",         default: false
    t.string   "raws_url"
    t.integer  "number_of_chapters",    default: 0
    t.datetime "last_modified",         default: '2015-11-16 08:26:43'
    t.string   "selector_next_chapter",                                 null: false
    t.string   "selector_name",                                         null: false
  end

  add_index "lightnovels", ["name"], name: "index_lightnovels_on_name", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "chapters", "lightnovels"
end
