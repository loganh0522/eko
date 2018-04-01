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

ActiveRecord::Schema.define(version: 20180401205430) do

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
    t.integer  "stage_id"
    t.integer  "candidate_id"
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.integer  "visit_id"
    t.integer  "user_id"
    t.string   "name"
    t.jsonb    "properties"
    t.datetime "time"
  end

  add_index "ahoy_events", ["name", "time"], name: "index_ahoy_events_on_name_and_time", using: :btree

  create_table "ahoy_visits", force: :cascade do |t|
    t.string   "visit_token"
    t.string   "visitor_token"
    t.integer  "user_id"
    t.string   "ip"
    t.text     "user_agent"
    t.text     "referrer"
    t.string   "referring_domain"
    t.string   "search_keyword"
    t.text     "landing_page"
    t.string   "browser"
    t.string   "os"
    t.string   "device_type"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.datetime "started_at"
  end

  add_index "ahoy_visits", ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true, using: :btree

  create_table "answers", force: :cascade do |t|
    t.integer "section_option_id"
    t.integer "rating"
    t.integer "user_id"
    t.integer "application_scorecard_id"
    t.integer "interview_scorecard_id"
    t.text    "body"
    t.integer "scorecard_answer_id"
    t.integer "question_id"
    t.string  "answerable"
    t.integer "answerable_id"
    t.integer "completed_assessment_id"
    t.string  "file"
    t.integer "question_option_id"
  end

  create_table "applicant_contact_details", force: :cascade do |t|
    t.integer  "application_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "email"
    t.string   "location"
    t.string   "city"
    t.string   "province"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "application_emails", force: :cascade do |t|
    t.text     "body"
    t.integer  "company_id"
    t.integer  "job_id"
    t.string   "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "application_scorecards", force: :cascade do |t|
    t.integer "scorecard_id"
    t.integer "user_id"
    t.integer "job_id"
    t.text    "feedback"
    t.integer "application_id"
    t.integer "overall"
    t.integer "assessment_id"
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
    t.boolean  "manually_created"
    t.string   "source"
    t.integer  "candidate_id"
    t.string   "rejection_reason"
    t.boolean  "hired",            default: false
  end

  create_table "assessment_templates", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assessments", force: :cascade do |t|
    t.integer  "application_id"
    t.integer  "candidate_id"
    t.integer  "interview_id"
    t.integer  "interview_kit_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "job_id"
    t.text     "preperation"
    t.string   "kind"
  end

  create_table "assigned_candidates", force: :cascade do |t|
    t.integer "candidate_id"
    t.integer "assignable_id"
    t.integer "assignable_type"
  end

  create_table "assigned_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "assignable_id"
    t.string  "assignable_type"
  end

  create_table "attachments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.string   "link"
    t.string   "file"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_type"
    t.string   "file_image"
    t.string   "video_url"
  end

  create_table "background_images", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "job_board_header_id"
    t.integer  "job_board_row_id"
    t.integer  "user_id"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blogs", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "body"
    t.string   "title"
    t.integer  "estimated_time"
    t.boolean  "published",      default: false
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "candidates", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "location"
    t.boolean  "manually_created"
    t.string   "source"
    t.string   "token"
    t.integer  "company_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_name"
  end

  add_index "candidates", ["company_id"], name: "index_candidates_on_company_id", using: :btree

  create_table "career_levels", force: :cascade do |t|
    t.string "name"
  end

  create_table "carts", force: :cascade do |t|
  end

  create_table "certifications", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "agency"
    t.string   "acronym"
    t.integer  "user_id"
  end

  create_table "client_contacts", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "full_name"
    t.string   "email"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "phone"
  end

  create_table "clients", force: :cascade do |t|
    t.string   "company_name"
    t.string   "address"
    t.string   "website"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "num_employees"
    t.string   "status"
    t.integer  "company_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "application_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.integer  "job_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "website"
    t.string   "subscription"
    t.boolean  "active",              default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "widget_key"
    t.string   "kind"
    t.integer  "job_count",           default: 0,     null: false
    t.integer  "max_jobs",            default: 3,     null: false
    t.string   "application_process"
    t.boolean  "verified",            default: false
    t.string   "location"
    t.string   "country"
    t.string   "city"
    t.string   "province"
    t.integer  "size"
    t.string   "address"
    t.string   "company_number"
  end

  create_table "company_users", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "completed_assessments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "assessment_id"
    t.integer  "stage_action_id"
    t.integer  "scorecard_id"
    t.integer  "interview_id"
    t.integer  "candidate_id"
    t.integer  "application_id"
    t.integer  "overall"
    t.text     "feedback"
    t.text     "candidate_feedback"
    t.text     "concerns"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_messages", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.string "message"
    t.string "company"
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "full_name"
    t.string   "email"
    t.string   "phone"
    t.string   "location"
    t.integer  "client_id"
    t.integer  "company_id"
    t.integer  "association_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "user_id"
    t.integer  "candidate_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "address"
    t.string   "city"
    t.string   "country"
    t.string   "state"
    t.string   "location"
    t.string   "card_brand"
  end

  create_table "default_stages", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "departments", force: :cascade do |t|
    t.integer  "subsidiary_id"
    t.integer  "location_id"
    t.integer  "company_id"
    t.string   "name"
    t.string   "description"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer "candidate_id"
    t.integer "user_id"
  end

  create_table "email_signatures", force: :cascade do |t|
    t.string   "signature"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "event_ids", force: :cascade do |t|
    t.integer "interview_time_id"
    t.string  "event_id"
    t.integer "user_id"
    t.integer "interview_id"
    t.integer "room_id"
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

  create_table "free_boards", force: :cascade do |t|
    t.string   "logo"
    t.text     "description"
    t.string   "name"
    t.string   "job_feed_name"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "functions", force: :cascade do |t|
    t.text "name"
  end

  create_table "google_tokens", force: :cascade do |t|
    t.string   "access_token"
    t.string   "refresh_token"
    t.datetime "expires_at"
    t.integer  "user_id"
    t.string   "history_id"
    t.string   "email"
  end

  create_table "header_links", force: :cascade do |t|
    t.integer  "job_board_row_id"
    t.integer  "job_board_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hiring_members", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hiring_teams", force: :cascade do |t|
    t.integer "user_id"
    t.integer "job_id"
  end

  create_table "industries", force: :cascade do |t|
    t.text    "name"
    t.integer "work_experience_id"
  end

  create_table "interview_invitations", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "body"
    t.string   "token"
    t.string   "status"
    t.string   "subject"
    t.string   "title"
    t.string   "location"
    t.string   "kind"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "duration"
    t.integer  "job_id"
    t.integer  "company_id"
    t.text     "message"
    t.string   "event_id"
    t.integer  "room_id"
    t.text     "details"
    t.integer  "stage_action_id"
    t.integer  "interview_kit_id"
    t.integer  "interview_kit_template_id"
  end

  create_table "interview_kit_templates", force: :cascade do |t|
    t.string   "title"
    t.integer  "company_id"
    t.text     "body"
    t.text     "preperation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interview_kits", force: :cascade do |t|
    t.integer  "application_id"
    t.integer  "candidate_id"
    t.integer  "stage_id"
    t.integer  "interview_id"
    t.integer  "rating"
    t.text     "concerns"
    t.text     "body"
    t.text     "preperation"
    t.integer  "company_id"
    t.string   "title"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "interview_scorecards", force: :cascade do |t|
    t.integer "interview_id"
    t.integer "interview_kit_id"
    t.integer "candidate_id"
    t.integer "application_id"
    t.integer "user_id"
    t.text    "feedback"
    t.integer "overall"
    t.integer "scorecard_id"
    t.integer "stage_action_id"
    t.text    "concerns"
    t.integer "assessment_id"
  end

  create_table "interview_times", force: :cascade do |t|
    t.string   "date"
    t.string   "time"
    t.integer  "interview_invitation_id"
    t.integer  "reschedule_event_id"
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "interviews", force: :cascade do |t|
    t.string   "notes"
    t.integer  "application_id"
    t.string   "kind"
    t.string   "location"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "job_id"
    t.integer  "company_id"
    t.string   "title"
    t.integer  "candidate_id"
    t.string   "event_id"
    t.string   "duration"
    t.integer  "room_id"
    t.text     "details"
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean  "send_request"
    t.string   "stime"
    t.string   "etime"
    t.string   "date"
    t.integer  "interview_kit_id"
    t.integer  "stage_action_id"
    t.integer  "stage_id"
    t.integer  "interview_kit_template_id"
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
    t.integer  "job_id"
    t.string   "user_role"
    t.string   "status"
    t.string   "first_name"
    t.string   "last_name"
  end

  create_table "invited_candidates", force: :cascade do |t|
    t.integer "interview_invitation_id"
    t.integer "candidate_id"
  end

  create_table "invited_interviewers", force: :cascade do |t|
    t.integer "user_id"
    t.integer "interview_invitation_id"
  end

  create_table "job_board_headers", force: :cascade do |t|
    t.integer  "job_board_id"
    t.string   "header"
    t.string   "subheader"
    t.string   "layout"
    t.string   "color_overlay"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_board_rows", force: :cascade do |t|
    t.integer  "job_board_id"
    t.string   "header"
    t.string   "subheader"
    t.string   "description"
    t.string   "video_link"
    t.integer  "position"
    t.string   "job_filters"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kind"
    t.string   "layout"
    t.string   "youtube_id"
  end

  create_table "job_boards", force: :cascade do |t|
    t.string  "subdomain"
    t.string  "logo"
    t.integer "company_id"
    t.text    "description"
    t.string  "cover_photo"
    t.string  "header"
    t.string  "subheader"
    t.string  "brand_color"
    t.string  "sub_heading_color"
    t.string  "text_color"
    t.string  "nav_color"
    t.string  "font_family"
    t.string  "kind"
    t.string  "app_process"
  end

  create_table "job_countries", force: :cascade do |t|
    t.integer "country_id"
    t.integer "job_id"
    t.integer "work_experience_id"
    t.integer "user_id"
  end

  create_table "job_feeds", force: :cascade do |t|
    t.integer  "job_id"
    t.boolean  "adzuna"
    t.boolean  "jooble"
    t.boolean  "indeed"
    t.boolean  "trovit"
    t.boolean  "juju"
    t.boolean  "eluta"
    t.boolean  "monster"
    t.boolean  "glassdoor"
    t.boolean  "careerjet"
    t.boolean  "ziprecruiter"
    t.boolean  "neuvoo"
    t.boolean  "jobinventory"
    t.boolean  "recruitnet"
    t.boolean  "jobisjob"
    t.boolean  "jobrapido"
    t.boolean  "usjobs"
    t.string   "ziprecruiter_boost"
    t.string   "indeed_boost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "juju_updated_at"
    t.boolean  "nuevoo_premium"
    t.integer  "indeed_budget"
    t.boolean  "career_builder"
    t.boolean  "dice"
    t.boolean  "stackoverflow"
  end

  create_table "job_functions", force: :cascade do |t|
    t.integer "job_id"
    t.integer "function_id"
  end

  create_table "job_industries", force: :cascade do |t|
    t.integer "job_id"
    t.integer "industry_id"
  end

  create_table "job_templates", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "department_id"
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.string   "start_salary"
    t.string   "end_salary"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "client_id"
    t.text     "recruiter_description"
    t.string   "token"
    t.boolean  "verified",              default: false
    t.string   "function"
    t.string   "industry"
    t.boolean  "is_active"
    t.integer  "department_id"
    t.integer  "location_id"
    t.integer  "subsidiary_id"
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

  create_table "logos", force: :cascade do |t|
    t.string   "file"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_photos", force: :cascade do |t|
    t.string  "file_name"
    t.integer "job_board_row_id"
    t.integer "premium_board_id"
  end

  create_table "mentions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "mentioned_id"
    t.integer "comment_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text     "body"
    t.string   "subject"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "messageable_type"
    t.integer  "messageable_id"
    t.integer  "candidate_id"
    t.string   "thread_id"
    t.integer  "conversation_id"
    t.integer  "job_id"
    t.string   "email_id"
    t.integer  "stage_action_id"
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

  create_table "order_items", force: :cascade do |t|
    t.integer  "cart_id"
    t.integer  "product_id"
    t.integer  "order_id"
    t.integer  "quantity"
    t.decimal  "total_price"
    t.decimal  "unit_price"
    t.integer  "premium_board_id"
    t.integer  "posting_duration_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "job_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "job_id"
    t.integer  "user_id"
    t.string   "status"
    t.decimal  "subtotal"
    t.decimal  "tax"
    t.decimal  "total"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "description"
    t.string   "last_four"
    t.datetime "invoice_date"
  end

  create_table "outlook_tokens", force: :cascade do |t|
    t.string   "access_token"
    t.string   "refresh_token"
    t.integer  "user_id"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "room_id"
    t.string   "subscription_id"
    t.datetime "subscription_expiration"
    t.string   "email"
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

  create_table "permissions", force: :cascade do |t|
    t.string  "name"
    t.integer "company_id"
    t.boolean "create_job",            default: true
    t.boolean "view_all_jobs",         default: true
    t.boolean "edit_job",              default: true
    t.boolean "add_team_members",      default: true
    t.boolean "create_candidates",     default: true
    t.boolean "edit_candidates",       default: true
    t.boolean "view_all_candidates",   default: true
    t.boolean "move_candidates",       default: true
    t.boolean "create_tasks",          default: true
    t.boolean "view_all_tasks",        default: true
    t.boolean "assign_tasks",          default: true
    t.boolean "send_messages",         default: true
    t.boolean "view_all_messages",     default: true
    t.boolean "view_section_messages", default: true
    t.boolean "create_event",          default: true
    t.boolean "view_events",           default: true
    t.boolean "send_event_invitation", default: true
    t.boolean "view_all_events",       default: true
    t.boolean "view_analytics",        default: true
    t.boolean "edit_career_portal",    default: true
    t.boolean "access_settings",       default: true
    t.boolean "advertise_job",         default: true
  end

  create_table "posting_durations", force: :cascade do |t|
    t.integer "premium_board_id"
    t.string  "duration"
    t.string  "kind"
    t.integer "price"
    t.decimal "real_price"
    t.string  "name"
  end

  create_table "premium_boards", force: :cascade do |t|
    t.string  "name"
    t.decimal "price"
    t.string  "logo"
    t.string  "website"
    t.string  "description"
    t.string  "kind"
    t.string  "line_item_title"
    t.boolean "email_to",        default: false
    t.boolean "contact_email"
  end

  create_table "profiles", force: :cascade do |t|
    t.integer "user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.integer "user_id"
    t.integer "work_experience_id"
    t.integer "education_id"
    t.string  "title"
    t.text    "description"
    t.text    "problem"
    t.text    "solution"
    t.text    "role"
  end

  create_table "question_answers", force: :cascade do |t|
    t.text    "body"
    t.integer "question_id"
    t.integer "application_id"
    t.integer "question_option_id"
    t.integer "candidate_id"
    t.integer "job_id"
    t.integer "user_id"
    t.integer "interview_kit_id"
    t.string  "file"
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
    t.integer "position"
    t.integer "job_id"
    t.integer "interview_kit_id"
    t.boolean "required",                  default: false
    t.integer "scorecard_id"
    t.text    "guidelines"
    t.integer "assessment_id"
    t.integer "interview_kit_template_id"
    t.integer "assessment_template_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "application_id"
    t.float    "score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "candidate_id"
  end

  create_table "rejection_reasons", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "application_id"
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reschedule_events", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "body"
    t.integer  "candidate_id"
    t.integer  "interview_invitation_id"
    t.integer  "company_id"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resumes", force: :cascade do |t|
    t.string   "name"
    t.string   "attachment"
    t.integer  "candidate_id"
    t.integer  "application_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "filetype"
  end

  create_table "rooms", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "email"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scorecard_sections", force: :cascade do |t|
    t.integer "scorecard_id"
    t.string  "body"
  end

  create_table "scorecard_templates", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scorecards", force: :cascade do |t|
    t.integer "job_id"
    t.integer "application_id"
    t.integer "interview_kit_id"
    t.integer "interview_id"
    t.text    "comments"
    t.text    "concerns"
    t.integer "interview_kit_template_id"
    t.integer "assessment_id"
  end

  create_table "section_options", force: :cascade do |t|
    t.integer "scorecard_section_id"
    t.string  "body"
    t.text    "quality_answer"
    t.integer "position"
    t.integer "scorecard_id"
    t.integer "scorecard_templates_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "skills", force: :cascade do |t|
    t.string "name"
  end

  create_table "social_links", force: :cascade do |t|
    t.string  "url"
    t.string  "kind"
    t.integer "user_id"
    t.integer "candidate_id"
  end

  create_table "stage_action_kits", force: :cascade do |t|
    t.integer  "stage_action_id"
    t.integer  "interview_kit_template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stage_actions", force: :cascade do |t|
    t.integer  "stage_id"
    t.integer  "assigned_to"
    t.integer  "interview_kit_id"
    t.text     "message"
    t.string   "subject"
    t.boolean  "automate"
    t.string   "name"
    t.string   "kind"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.string   "title"
    t.datetime "due_date"
    t.boolean  "is_scheduled",              default: false
    t.boolean  "sent_request",              default: false
    t.boolean  "is_complete",               default: false
    t.string   "standard_stage"
    t.integer  "job_id"
    t.integer  "interview_kit_template_id"
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
    t.integer "subsidiary_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "candidate_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "company_id"
    t.integer "candidate_id"
    t.integer "project_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.integer  "taskable_id"
    t.string   "taskable_type"
    t.integer  "user_id"
    t.string   "title"
    t.text     "notes"
    t.date     "due_date"
    t.integer  "stage_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.string   "kind"
    t.string   "due_time"
    t.string   "status"
    t.integer  "job_id"
    t.integer  "completed_by_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "stage_action_id"
  end

  create_table "team_members", force: :cascade do |t|
    t.string   "file"
    t.string   "name"
    t.string   "position"
    t.string   "details"
    t.integer  "job_board_row_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "user_id"
  end

  create_table "user_skills", force: :cascade do |t|
    t.integer "user_id"
    t.integer "skill_id"
    t.integer "profile_id"
    t.integer "work_experience_id"
    t.integer "project_id"
    t.string  "name"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "password_digest"
    t.integer  "company_id"
    t.string   "kind"
    t.string   "role"
    t.string   "token"
    t.string   "city"
    t.string   "phone"
    t.string   "linked_in"
    t.string   "website"
    t.string   "tag_line"
    t.string   "location"
    t.string   "province"
    t.string   "country"
    t.string   "email_signature"
    t.string   "full_name"
    t.string   "profile_stage"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.integer  "permission_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

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
    t.integer  "candidate_id"
    t.integer  "user_id"
    t.string   "function"
    t.string   "industry"
    t.string   "skill"
  end

end
