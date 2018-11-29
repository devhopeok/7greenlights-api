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

ActiveRecord::Schema.define(version: 20180626224346) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "arenas", force: :cascade do |t|
    t.string   "name",              default: ""
    t.string   "image"
    t.string   "description",       default: ""
    t.datetime "end_date",                          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_feature",        default: false
    t.integer  "greenlights_count", default: 0
    t.text     "blast"
  end

  add_index "arenas", ["is_feature"], name: "index_arenas_on_is_feature", where: "(is_feature = true)", using: :btree
  add_index "arenas", ["name"], name: "index_arenas_on_name", unique: true, using: :btree

  create_table "arenas_sponsors", id: false, force: :cascade do |t|
    t.integer "arena_id"
    t.integer "sponsor_id"
  end

  add_index "arenas_sponsors", ["arena_id"], name: "index_arenas_sponsors_on_arena_id", using: :btree
  add_index "arenas_sponsors", ["sponsor_id"], name: "index_arenas_sponsors_on_sponsor_id", using: :btree

  create_table "blasts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blasts", ["user_id"], name: "index_blasts_on_user_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "greenlights", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "greenlighteable_id"
    t.string   "greenlighteable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "friendship_status",    default: 0
  end

  add_index "greenlights", ["greenlighteable_type", "greenlighteable_id"], name: "index_greenlighteable", using: :btree
  add_index "greenlights", ["user_id"], name: "index_greenlights_on_user_id", using: :btree

  create_table "media_contents", force: :cascade do |t|
    t.string   "name"
    t.string   "media_url"
    t.json     "links"
    t.boolean  "is_hidden",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "greenlights_count", default: 0
    t.string   "username"
    t.integer  "content_type",      default: 0
    t.string   "image"
  end

  add_index "media_contents", ["content_type"], name: "index_media_contents_on_content_type", using: :btree
  add_index "media_contents", ["is_hidden"], name: "index_media_contents_on_is_hidden", using: :btree
  add_index "media_contents", ["user_id"], name: "index_media_contents_on_user_id", using: :btree
  add_index "media_contents", ["username"], name: "index_media_contents_on_username", using: :btree

  create_table "notes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "media_content_id"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order",             default: 0
    t.boolean  "is_feature",        default: false
    t.integer  "greenlights_count"
  end

  add_index "notes", ["is_feature"], name: "index_notes_on_is_feature", using: :btree
  add_index "notes", ["media_content_id"], name: "index_notes_on_media_content_id", using: :btree
  add_index "notes", ["order"], name: "index_notes_on_order", using: :btree
  add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "event_entity_id"
    t.string   "event_entity_type"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["event_entity_type", "event_entity_id"], name: "index_notifications_on_event_entity_type_and_event_entity_id", using: :btree
  add_index "notifications", ["receiver_id"], name: "index_notifications_on_receiver_id", using: :btree
  add_index "notifications", ["sender_id"], name: "index_notifications_on_sender_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.integer  "arena_id"
    t.integer  "media_content_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["arena_id"], name: "index_posts_on_arena_id", using: :btree
  add_index "posts", ["media_content_id"], name: "index_posts_on_media_content_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "redirection_hits", force: :cascade do |t|
    t.string   "origin"
    t.string   "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reports", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "media_content_id"
    t.text     "message"
    t.boolean  "solved",           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reports", ["media_content_id"], name: "index_reports_on_media_content_id", using: :btree
  add_index "reports", ["user_id"], name: "index_reports_on_user_id", using: :btree

  create_table "sponsors", force: :cascade do |t|
    t.string "name"
    t.string "picture"
    t.string "url"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: ""
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "authentication_token",   default: ""
    t.string   "username",               default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "facebook_id"
    t.string   "instagram_id"
    t.date     "birthday"
    t.integer  "greenlights_count",      default: 0
    t.string   "picture"
    t.jsonb    "social_media_links"
    t.text     "about"
    t.text     "goals"
    t.string   "last_blast"
    t.boolean  "active",                 default: true
    t.text     "channel"
    t.jsonb    "tooltips"
  end

  add_index "users", ["active"], name: "index_users_on_active", using: :btree
  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["facebook_id"], name: "index_users_on_facebook_id", unique: true, using: :btree
  add_index "users", ["instagram_id"], name: "index_users_on_instagram_id", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

  add_foreign_key "notifications", "users", column: "receiver_id", on_delete: :cascade
  add_foreign_key "notifications", "users", column: "sender_id", on_delete: :cascade

  create_view :arena_content_greenlights_counts, materialized: true,  sql_definition: <<-SQL
      SELECT p.arena_id,
      sum(m.greenlights_count) AS sum
     FROM (posts p
       JOIN media_contents m ON ((p.media_content_id = m.id)))
    GROUP BY p.arena_id;
  SQL

  create_view :friendships, materialized: true,  sql_definition: <<-SQL
      SELECT g.greenlighteable_id AS user_id,
      g.user_id AS friend_id
     FROM greenlights g
    WHERE ((g.friendship_status = 3) AND ((g.greenlighteable_type)::text = 'User'::text))
  UNION ALL
   SELECT g.user_id,
      g.greenlighteable_id AS friend_id
     FROM greenlights g
    WHERE ((g.friendship_status = 3) AND ((g.greenlighteable_type)::text = 'User'::text));
  SQL

  create_view :followers,  sql_definition: <<-SQL
      SELECT greenlights.greenlighteable_id AS user_id,
      greenlights.user_id AS follower_user_id,
      greenlights.friendship_status
     FROM greenlights
    WHERE ((greenlights.friendship_status = 2) AND ((greenlights.greenlighteable_type)::text = 'User'::text))
  UNION ALL
   SELECT greenlights.user_id,
      greenlights.greenlighteable_id AS follower_user_id,
      greenlights.friendship_status
     FROM greenlights
    WHERE ((greenlights.friendship_status = 1) AND ((greenlights.greenlighteable_type)::text = 'User'::text));
  SQL

end
