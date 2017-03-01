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

ActiveRecord::Schema.define(version: 20170228234516) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accomplishments", force: :cascade do |t|
    t.integer "work_experience_id"
    t.text    "body"
  end

  create_table "activities", force: :cascade do |t|
    t.string   "action"
    t.string   "trackable_type"
    t.integer  "trackable_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "application_id"
    t.integer  "company_id"
    t.integer  "job_id"
  end

  create_table "application_scorecards", force: :cascade do |t|
    t.integer "scorecard_id"
    t.integer "user_id"
    t.integer "job_id"
    t.text    "feedback"
    t.integer "application_id"
  end

  create_table "applications", force: :cascade do |t|
    t.integer  "job_id"
    t.integer  "user_id"
    t.integer  "stage_id"
    t.integer  "company_id"
    t.string   "token"
    t.boolean  "rejected"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "career_levels", force: :cascade do |t|
    t.string "name"
  end

  create_table "certifications", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "agency"
    t.string   "acronym"
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "application_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "website"
    t.integer  "open_jobs",    default: 0,    null: false
    t.string   "subscription"
    t.boolean  "active",       default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "widget_key"
  end

  create_table "contact_messages", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.string "message"
    t.string "company"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
  end

  create_table "customers", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "plan"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_customer_id"
    t.string   "last_four"
    t.string   "stripe_subscription_id"
    t.string   "full_name"
    t.string   "postal_code"
    t.integer  "exp_month"
    t.integer  "exp_year"
  end

  create_table "demos", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.string "message"
    t.string "company"
    t.string "company_size"
    t.string "company_website"
    t.string "demo"
  end

  create_table "education_levels", force: :cascade do |t|
    t.string "name"
  end

  create_table "educations", force: :cascade do |t|
    t.string  "start_month"
    t.string  "start_year"
    t.string  "end_month"
    t.string  "end_year"
    t.string  "school"
    t.string  "degree"
    t.text    "description"
    t.integer "profile_id"
  end

  create_table "email_templates", force: :cascade do |t|
    t.string   "title"
    t.string   "subject"
    t.string   "body"
    t.string   "shared"
    t.string   "created_by"
    t.integer  "user_id"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exp_functions", force: :cascade do |t|
    t.integer "function_id"
    t.integer "work_experience_id"
  end

  create_table "exp_industries", force: :cascade do |t|
    t.integer "industry_id"
    t.integer "work_experience_id"
  end

  create_table "experience_levels", force: :cascade do |t|
    t.text "name"
  end

  create_table "functions", force: :cascade do |t|
    t.text "name"
  end

  create_table "google_tokens", force: :cascade do |t|
    t.string   "access_token"
    t.string   "refresh_token"
    t.datetime "expires_at"
    t.integer  "user_id"
  end

  create_table "hiring_teams", force: :cascade do |t|
    t.integer "user_id"
    t.integer "job_id"
  end

  create_table "industries", force: :cascade do |t|
    t.text    "name"
    t.integer "work_experience_id"
  end

  create_table "interviews", force: :cascade do |t|
    t.string   "notes"
    t.integer  "application_id"
    t.string   "kind"
    t.string   "start_time"
    t.string   "end_time"
    t.string   "location"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "job_id"
    t.integer  "company_id"
    t.date     "interview_date"
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

  create_table "job_countries", force: :cascade do |t|
    t.integer "country_id"
    t.integer "job_id"
    t.integer "work_experience_id"
    t.integer "user_id"
  end

  create_table "job_functions", force: :cascade do |t|
    t.integer "job_id"
    t.integer "function_id"
  end

  create_table "job_industries", force: :cascade do |t|
    t.integer "job_id"
    t.integer "industry_id"
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
    t.string   "status"
    t.string   "url"
    t.string   "address"
    t.string   "location"
    t.string   "start_salary"
    t.string   "end_salary"
    t.string   "education_level"
    t.string   "career_level"
    t.string   "kind"
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

  create_table "mentions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "mentioned_id"
    t.integer "comment_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text     "body"
    t.string   "subject"
    t.integer  "application_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "my_interviews", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "interview_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "action"
    t.string   "trackable_type"
    t.integer  "trackable_id"
    t.integer  "user_id"
    t.integer  "company_id"
    t.integer  "application_id"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "overall_ratings", force: :cascade do |t|
    t.integer "rating"
    t.integer "user_id"
    t.integer "application_scorecard_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "amount"
    t.string   "reference_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", force: :cascade do |t|
    t.integer "user_id"
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

  create_table "ratings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "application_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "skills", force: :cascade do |t|
    t.string "name"
  end

  create_table "stages", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", force: :cascade do |t|
    t.string  "name"
    t.integer "country_id"
  end

  create_table "subsidiaries", force: :cascade do |t|
    t.string  "name"
    t.integer "company_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "application_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "company_id"
  end

  create_table "user_avatars", force: :cascade do |t|
    t.string   "image"
    t.string   "small_image"
    t.string   "medium_image"
    t.string   "large_image"
    t.string   "xs_image"
    t.string   "xl_image"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_certifications", force: :cascade do |t|
    t.integer  "certification_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.string   "agency"
    t.string   "start_month"
    t.string   "start_year"
    t.string   "end_month"
    t.string   "end_year"
    t.integer  "expires"
    t.integer  "profile_id"
    t.string   "name"
  end

  create_table "user_skills", force: :cascade do |t|
    t.integer "user_id"
    t.integer "skill_id"
    t.integer "profile_id"
  end

  create_table "users", force: :cascade do |t|
    t.string  "email"
    t.string  "first_name"
    t.string  "last_name"
    t.string  "password_digest"
    t.integer "company_id"
    t.string  "kind"
    t.string  "role"
    t.string  "token"
    t.string  "city"
    t.string  "phone"
    t.string  "linked_in"
    t.string  "website"
    t.string  "tag_line"
    t.string  "full_name"
    t.string  "location"
    t.string  "province"
    t.string  "country"
  end

  create_table "work_experiences", force: :cascade do |t|
    t.string   "title"
    t.string   "company_name"
    t.text     "description"
    t.integer  "current_position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "start_month"
    t.string   "start_year"
    t.string   "end_month"
    t.string   "end_year"
    t.string   "country"
    t.string   "state"
    t.string   "city"
    t.integer  "profile_id"
    t.string   "location"
    t.integer  "position"
  end

end
