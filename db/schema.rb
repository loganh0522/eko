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

ActiveRecord::Schema.define(version: 20160112135135) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "website"
  end

  create_table "customers", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "stripe_id"
    t.string   "plan"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hiring_teams", force: :cascade do |t|
    t.integer "user_id"
    t.integer "job_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.integer  "inviter_id"
    t.string   "recipient_name"
    t.string   "recipient_email"
    t.text     "message"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.integer  "subsidiary_id"
    t.integer  "location_id"
    t.integer  "user_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "title"
    t.string   "country"
    t.string   "province"
    t.string   "city"
    t.string   "postal_code"
    t.text     "description"
    t.text     "benefits"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string  "name"
    t.string  "address"
    t.string  "city"
    t.string  "state"
    t.string  "country"
    t.string  "number"
    t.integer "company_id"
    t.integer "subsidiary_id"
  end

  create_table "stages", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subsidiaries", force: :cascade do |t|
    t.string  "name"
    t.integer "company_id"
  end

  create_table "users", force: :cascade do |t|
    t.string  "email"
    t.string  "first_name"
    t.string  "last_name"
    t.string  "password_digest"
    t.integer "company_id"
  end

end
