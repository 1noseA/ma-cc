# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_04_30_001607) do
  create_table "articles", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.boolean "published", default: true, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  create_table "display_rules", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "enabled", default: true, null: false
    t.integer "form_id", null: false
    t.string "rule_type", null: false
    t.integer "threshold"
    t.datetime "updated_at", null: false
    t.index ["form_id"], name: "index_display_rules_on_form_id"
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "event_type", null: false
    t.datetime "occurred_at", null: false
    t.string "path", null: false
    t.datetime "updated_at", null: false
    t.integer "visitor_id", null: false
    t.index ["event_type"], name: "index_events_on_event_type"
    t.index ["visitor_id", "occurred_at"], name: "index_events_on_visitor_id_and_occurred_at"
    t.index ["visitor_id"], name: "index_events_on_visitor_id"
  end

  create_table "form_submissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.integer "form_id", null: false
    t.string "name", null: false
    t.datetime "submitted_at", null: false
    t.datetime "updated_at", null: false
    t.integer "visitor_id", null: false
    t.index ["form_id"], name: "index_form_submissions_on_form_id"
    t.index ["visitor_id"], name: "index_form_submissions_on_visitor_id"
  end

  create_table "forms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name"
    t.string "success_message"
    t.datetime "updated_at", null: false
  end

  create_table "leads", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.datetime "first_converted_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.integer "visitor_id", null: false
    t.index ["visitor_id"], name: "index_leads_on_visitor_id", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "visitors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "first_visited_at"
    t.datetime "last_visited_at"
    t.integer "score", default: 0
    t.datetime "updated_at", null: false
    t.string "visitor_token"
    t.index ["score"], name: "index_visitors_on_score"
    t.index ["visitor_token"], name: "index_visitors_on_visitor_token", unique: true
  end

  add_foreign_key "display_rules", "forms"
  add_foreign_key "events", "visitors"
  add_foreign_key "form_submissions", "forms"
  add_foreign_key "form_submissions", "visitors"
  add_foreign_key "leads", "visitors"
  add_foreign_key "sessions", "users"
end
