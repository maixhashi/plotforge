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

ActiveRecord::Schema[7.1].define(version: 2024_09_16_174105) do
  create_table "appearance_of_characters", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.bigint "shuffled_overview_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_appearance_of_characters_on_character_id"
    t.index ["shuffled_overview_id"], name: "index_appearance_of_characters_on_shuffled_overview_id"
  end

  create_table "bookmark_of_movies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "movie_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_bookmark_of_movies_on_movie_id"
    t.index ["user_id"], name: "index_bookmark_of_movies_on_user_id"
  end

  create_table "bookmark_of_shuffled_overviews", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "shuffled_overview_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shuffled_overview_id"], name: "index_bookmark_of_shuffled_overviews_on_shuffled_overview_id"
    t.index ["user_id", "shuffled_overview_id"], name: "index_bookmarks_on_user_and_overview", unique: true
    t.index ["user_id"], name: "index_bookmark_of_shuffled_overviews_on_user_id"
  end

  create_table "characters", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_characters_on_name"
  end

  create_table "follows", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "follower_id"
    t.bigint "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_follows_on_followed_id"
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "keywords", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "link_of_shuffled_overview_movies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "shuffled_overview_id", null: false
    t.bigint "movie_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_link_of_shuffled_overview_movies_on_movie_id"
    t.index ["shuffled_overview_id", "movie_id"], name: "index_shuffled_overview_movie_ids", unique: true
    t.index ["shuffled_overview_id"], name: "index_link_of_shuffled_overview_movies_on_shuffled_overview_id"
  end

  create_table "movies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "tmdb_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tmdb_id"], name: "index_movies_on_tmdb_id"
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "visitor_id", null: false
    t.integer "visited_id", null: false
    t.integer "shuffled_overview_id"
    t.integer "movie_id"
    t.string "action", default: "", null: false
    t.boolean "checked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_notifications_on_movie_id"
    t.index ["shuffled_overview_id"], name: "index_notifications_on_shuffled_overview_id"
    t.index ["visited_id"], name: "index_notifications_on_visited_id"
    t.index ["visitor_id"], name: "index_notifications_on_visitor_id"
  end

  create_table "settings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "notification"
    t.boolean "dark_mode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_settings_on_user_id"
  end

  create_table "shuffled_overview_keywords", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "shuffled_overview_id", null: false
    t.bigint "keyword_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["keyword_id"], name: "index_shuffled_overview_keywords_on_keyword_id"
    t.index ["shuffled_overview_id"], name: "index_shuffled_overview_keywords_on_shuffled_overview_id"
  end

  create_table "shuffled_overviews", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "related_movie_ids"
    t.json "related_movie_genres"
    t.index ["user_id"], name: "index_shuffled_overviews_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "avatar"
    t.string "profile_sentence"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "appearance_of_characters", "characters"
  add_foreign_key "appearance_of_characters", "shuffled_overviews"
  add_foreign_key "bookmark_of_movies", "movies"
  add_foreign_key "bookmark_of_movies", "users"
  add_foreign_key "bookmark_of_shuffled_overviews", "shuffled_overviews"
  add_foreign_key "bookmark_of_shuffled_overviews", "users"
  add_foreign_key "follows", "users", column: "followed_id"
  add_foreign_key "follows", "users", column: "follower_id"
  add_foreign_key "link_of_shuffled_overview_movies", "movies"
  add_foreign_key "link_of_shuffled_overview_movies", "shuffled_overviews"
  add_foreign_key "settings", "users"
  add_foreign_key "shuffled_overview_keywords", "keywords"
  add_foreign_key "shuffled_overview_keywords", "shuffled_overviews"
  add_foreign_key "shuffled_overviews", "users"
end
