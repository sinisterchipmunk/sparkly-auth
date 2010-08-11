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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100810132843) do

  create_table "passwords", :force => true do |t|
    t.string   "secret"
    t.string   "salt"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "authenticatable_id"
    t.string   "authenticatable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "remembrance_tokens", :force => true do |t|
    t.string   "series_token"
    t.string   "remembrance_token"
    t.integer  "authenticatable_id"
    t.string   "authenticatable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
