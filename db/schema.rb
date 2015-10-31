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

ActiveRecord::Schema.define(version: 20151029223548) do

  create_table "chapters", force: :cascade do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "lightnovel_id",  null: false
    t.string   "chapter_name",   null: false
    t.integer  "chapter_number", null: false
    t.string   "chapter_url",    null: false
    t.string   "raws_url"
  end

  create_table "examples", force: :cascade do |t|
    t.string   "name"
    t.string   "integer"
    t.string   "desc"
    t.string   "string"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lightnovels", force: :cascade do |t|
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "name",                                               null: false
    t.string   "description",                                        null: false
    t.string   "home_url",                                           null: false
    t.boolean  "is_translated",      default: false
    t.string   "raws_url"
    t.integer  "number_of_chapters", default: 0
    t.datetime "last_modified",      default: '2015-10-30 22:30:23'
  end

  create_table "selectors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "url_base",   null: false
    t.string   "selector",   null: false
    t.string   "name",       null: false
  end

end
