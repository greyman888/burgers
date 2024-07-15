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

ActiveRecord::Schema[7.1].define(version: 2024_07_15_040956) do
  create_table "items", force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.string "size"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "modifications", force: :cascade do |t|
    t.integer "selection_id", null: false
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_modifications_on_item_id"
    t.index ["selection_id"], name: "index_modifications_on_selection_id"
  end

  create_table "orders", force: :cascade do |t|
    t.text "chunk"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "selections", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_selections_on_item_id"
    t.index ["order_id"], name: "index_selections_on_order_id"
  end

  add_foreign_key "modifications", "items"
  add_foreign_key "modifications", "selections"
  add_foreign_key "selections", "items"
  add_foreign_key "selections", "orders"
end
