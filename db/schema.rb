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

ActiveRecord::Schema.define(version: 2019_10_15_194144) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comment_replies", force: :cascade do |t|
    t.text "body"
    t.bigint "reporter_id"
    t.bigint "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_comment_replies_on_comment_id"
    t.index ["reporter_id"], name: "index_comment_replies_on_reporter_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.bigint "incident_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "reporter_id"
    t.index ["incident_id"], name: "index_comments_on_incident_id"
    t.index ["reporter_id"], name: "index_comments_on_reporter_id"
  end

  create_table "follows", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "following_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "incident_types", force: :cascade do |t|
    t.string "title"
  end

  create_table "incidents", force: :cascade do |t|
    t.text "title"
    t.text "evidence"
    t.text "narration"
    t.text "location"
    t.string "status"
    t.integer "reporter_id"
    t.integer "incident_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reporters", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "phone"
    t.text "location"
    t.text "bio"
    t.text "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_admin", default: false
  end

  add_foreign_key "comment_replies", "comments"
  add_foreign_key "comment_replies", "reporters"
  add_foreign_key "comments", "incidents"
  add_foreign_key "comments", "reporters"
  add_foreign_key "follows", "incidents", column: "following_id", on_delete: :cascade
  add_foreign_key "follows", "reporters", column: "follower_id", on_delete: :cascade
  add_foreign_key "incidents", "incident_types"
  add_foreign_key "incidents", "reporters", on_delete: :cascade
end
