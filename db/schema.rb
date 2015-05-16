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

ActiveRecord::Schema.define(version: 20150515234736) do

  create_table "data_correlations", force: true do |t|
    t.float   "s_coeff",   limit: 24
    t.float   "p_coeff",   limit: 24
    t.integer "event1_id", limit: 4
    t.integer "event2_id", limit: 4
  end

  create_table "data_files", force: true do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "data_points", force: true do |t|
    t.integer  "value_1",      limit: 4
    t.float    "value_2",      limit: 24
    t.integer  "value_2_id",   limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "value_1_id",   limit: 4
    t.integer  "data_type_id", limit: 4
  end

  create_table "data_type_tags", force: true do |t|
    t.integer  "tag_id",       limit: 4
    t.integer  "data_type_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "data_types", force: true do |t|
    t.string   "name",       limit: 255
    t.text     "url",        limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "events", force: true do |t|
    t.string   "name",          limit: 255
    t.text     "description",   limit: 65535
    t.integer  "time_slice_id", limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "posts", force: true do |t|
    t.string   "title",      limit: 255
    t.text     "body",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "states", force: true do |t|
    t.string   "name",       limit: 255
    t.integer  "pop",        limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "tags", force: true do |t|
    t.string "name", limit: 255
  end

  create_table "time_slices", force: true do |t|
    t.integer  "year",       limit: 4
    t.integer  "population", limit: 8
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "gdp",        limit: 8
  end

  create_table "value_types", force: true do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
