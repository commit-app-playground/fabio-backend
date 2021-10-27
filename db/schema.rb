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

ActiveRecord::Schema.define(version: 2021_10_27_144247) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_book_memberships", force: :cascade do |t|
    t.bigint "account_book_id", null: false
    t.bigint "person_id", null: false
    t.string "role", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_book_id"], name: "index_account_book_memberships_on_account_book_id"
    t.index ["person_id"], name: "index_account_book_memberships_on_person_id"
  end

  create_table "account_books", force: :cascade do |t|
    t.string "name", default: "default", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_book_id", null: false
    t.index ["account_book_id"], name: "index_accounts_on_account_book_id"
  end

  create_table "bill_payments", force: :cascade do |t|
    t.bigint "bill_id", null: false
    t.date "date", null: false
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bill_id"], name: "index_bill_payments_on_bill_id"
  end

  create_table "bills", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "name", null: false
    t.integer "day", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_bills_on_account_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "account_book_memberships", "account_books"
  add_foreign_key "account_book_memberships", "people"
  add_foreign_key "accounts", "account_books"
  add_foreign_key "bill_payments", "bills"
  add_foreign_key "bills", "accounts"
end
