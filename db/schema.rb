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

ActiveRecord::Schema.define(version: 20160224153728) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "application_scorecards", force: :cascade do |t|
    t.integer "scorecard_id"
    t.integer "user_id"
    t.integer "job_id"
    t.text    "feedback"
    t.integer "application_id"
  end

  create_table "applications", force: :cascade do |t|
    t.integer "job_id"
    t.integer "user_id"
    t.integer "stage_id"
  end

  create_table "career_levels", force: :cascade do |t|
    t.string "name"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "application_id"
    t.text    "body"
  end

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

  create_table "education_levels", force: :cascade do |t|
    t.string "name"
  end

  create_table "experience_levels", force: :cascade do |t|
    t.text "name"
  end

  create_table "functions", force: :cascade do |t|
    t.text "name"
  end

  create_table "hiring_teams", force: :cascade do |t|
    t.integer "user_id"
    t.integer "job_id"
  end

  create_table "industries", force: :cascade do |t|
    t.text    "name"
    t.integer "work_experience_id"
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
    t.integer  "job"
  end

  create_table "job_boards", force: :cascade do |t|
    t.string  "subdomain"
    t.string  "logo"
    t.integer "company_id"
    t.text    "description"
  end

  create_table "job_career_levels", force: :cascade do |t|
    t.integer "job_id"
    t.integer "career_level_id"
  end

  create_table "job_education_levels", force: :cascade do |t|
    t.integer "job_id"
    t.integer "education_level_id"
  end

  create_table "job_experience_levels", force: :cascade do |t|
    t.integer "job_id"
    t.integer "experience_level_id"
  end

  create_table "job_functions", force: :cascade do |t|
    t.integer "job_id"
    t.integer "function_id"
  end

  create_table "job_industries", force: :cascade do |t|
    t.integer "job_id"
    t.integer "industry_id"
  end

  create_table "job_kinds", force: :cascade do |t|
    t.string "name"
  end

  create_table "job_types", force: :cascade do |t|
    t.integer "job_id"
    t.integer "job_kind_id"
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

  create_table "question_answers", force: :cascade do |t|
    t.text    "body"
    t.integer "question_id"
    t.integer "application_id"
    t.integer "question_option_id"
  end

  create_table "question_options", force: :cascade do |t|
    t.text    "body"
    t.integer "question_id"
  end

  create_table "questionairres", force: :cascade do |t|
    t.integer "job_id"
    t.integer "application_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text    "body"
    t.text    "kind"
    t.integer "questionairre_id"
    t.integer "required"
    t.integer "position"
  end

  create_table "scorecard_ratings", force: :cascade do |t|
    t.integer "section_option_id"
    t.integer "rating"
    t.integer "user_id"
    t.integer "application_scorecard_id"
  end

  create_table "scorecard_sections", force: :cascade do |t|
    t.integer "scorecard_id"
    t.string  "body"
  end

  create_table "scorecards", force: :cascade do |t|
    t.integer "job_id"
    t.integer "application_id"
  end

  create_table "section_options", force: :cascade do |t|
    t.integer "scorecard_section_id"
    t.string  "body"
  end

  create_table "sent_messages", force: :cascade do |t|
    t.text    "body"
    t.string  "subject"
    t.integer "application_id"
    t.integer "user_id"
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
    t.string  "kind"
    t.string  "role"
  end

  create_table "work_experiences", force: :cascade do |t|
    t.string   "title"
    t.string   "company_name"
    t.string   "start_date"
    t.string   "end_date"
    t.text     "description"
    t.integer  "current_position"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
