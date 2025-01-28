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

ActiveRecord::Schema[8.0].define(version: 2025_01_28_012524) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "blacklists", id: :serial, force: :cascade do |t|
    t.text "list", default: ""
    t.text "title_list", default: ""
  end

  create_table "forums", id: :serial, force: :cascade do |t|
    t.text "name"
    t.text "description"
    t.integer "topics_count", default: 0
    t.integer "posts_count", default: 0
    t.integer "position"
    t.text "description_html"
  end

  create_table "logged_exceptions", id: :serial, force: :cascade do |t|
    t.string "exception_class", limit: 255
    t.string "controller_name", limit: 255
    t.string "action_name", limit: 255
    t.text "message"
    t.text "backtrace"
    t.text "environment"
    t.text "request"
    t.datetime "created_at", precision: nil
  end

  create_table "moderatorships", id: :serial, force: :cascade do |t|
    t.integer "forum_id"
    t.integer "user_id"
    t.index ["forum_id"], name: "index_moderatorships_on_forum_id"
  end

  create_table "monitorships", id: :serial, force: :cascade do |t|
    t.integer "topic_id"
    t.integer "user_id"
    t.boolean "active", default: true
  end

  create_table "posts", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "topic_id"
    t.text "body"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "forum_id"
    t.text "body_html"
    t.index ["created_at"], name: "index_posts_on_created_at", order: :desc
    t.index ["forum_id", "created_at"], name: "index_posts_on_forum_id"
    t.index ["user_id", "created_at"], name: "index_posts_on_user_id"
  end

  create_table "sessions", id: :serial, force: :cascade do |t|
    t.string "session_id", limit: 255
    t.text "data"
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
    t.index ["session_id"], name: "index_sessions_on_session_id"
  end

  create_table "topics", id: :serial, force: :cascade do |t|
    t.integer "forum_id"
    t.integer "user_id"
    t.text "title"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "hits", default: 0
    t.integer "posts_count", default: 0
    t.datetime "replied_at", precision: nil
    t.integer "sticky", default: 0
    t.boolean "locked", default: false
    t.integer "replied_by"
    t.integer "last_post_id"
    t.index ["forum_id", "sticky", "replied_at"], name: "index_topics_on_forum_id_and_sticky_and_replied_at"
    t.index ["forum_id"], name: "index_topics_on_forum_id"
    t.index ["sticky", "replied_at"], name: "index_topics_on_sticky_and_replied_at", order: { sticky: :desc }
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.text "login"
    t.text "email"
    t.text "password_hash"
    t.datetime "created_at", precision: nil
    t.datetime "last_login_at", precision: nil
    t.boolean "admin"
    t.integer "posts_count", default: 0
    t.datetime "last_seen_at", precision: nil
    t.text "display_name"
    t.datetime "updated_at", precision: nil
    t.text "website"
    t.text "login_key"
    t.datetime "login_key_expires_at", precision: nil
    t.boolean "activated", default: false
    t.text "bio"
    t.text "bio_html"
    t.index ["last_seen_at"], name: "index_users_on_last_seen_at"
  end
end
