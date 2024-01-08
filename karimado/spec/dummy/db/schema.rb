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

ActiveRecord::Schema[7.1].define(version: 2024_01_01_092045) do
  create_table "karimado_user_authentications", force: :cascade do |t|
    t.string "provider", null: false
    t.string "uid", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_karimado_user_authentications_on_provider_and_uid", unique: true
    t.index ["user_id", "provider"], name: "index_karimado_user_authentications_on_user_id_and_provider", unique: true
    t.index ["user_id"], name: "index_karimado_user_authentications_on_user_id"
  end

  create_table "karimado_user_sessions", force: :cascade do |t|
    t.string "public_id", null: false
    t.string "access_token_base", null: false
    t.string "refresh_token_base", null: false
    t.datetime "discarded_at"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_karimado_user_sessions_on_discarded_at"
    t.index ["public_id"], name: "index_karimado_user_sessions_on_public_id", unique: true
    t.index ["user_id"], name: "index_karimado_user_sessions_on_user_id"
  end

  create_table "karimado_users", force: :cascade do |t|
    t.string "public_id", null: false
    t.string "uid", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["public_id"], name: "index_karimado_users_on_public_id", unique: true
    t.index ["uid"], name: "index_karimado_users_on_uid", unique: true
  end

end
