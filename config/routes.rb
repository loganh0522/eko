require 'sidekiq/web'

Rails.application.routes.draw do
  post '/rate' => 'rater#create', :as => 'rate'

  if lambda {|r| r.subdomain != 'd2a80095'}
    match '/', to: "job_boards#index", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != '6d4d48ec'}, via: [:get, :post, :put, :patch, :delete]
    match 'login', to: "sessions#subdomain_new", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != '6d4d48ec'}, via: [:get]
    match 'login', to: "sessions#create", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != '6d4d48ec'}, via: [:post]
    match 'jobs/:id', to: "jobs#show", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != '6d4d48ec'}, via: [:get, :post, :put, :patch, :delete]
    match 'register', to: "users#sub_new_job_seeker", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != '6d4d48ec'}, via: [:get, :post, :put, :patch, :delete]
    match 'profile', to: "profiles#index", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != '6d4d48ec'}, via: [:get, :post, :put, :patch, :delete]
    match 'create-profile', to: "profiles#new", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != '6d4d48ec'}, via: [:get, :post, :put, :patch, :delete]
    match 'companies', to: "companies#index", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != '6d4d48ec'}, via: [:get, :post, :put, :patch, :delete]
    match 'company/:id', to: "companies#show", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != '6d4d48ec'}, via: [:get, :post, :put, :patch, :delete]
    match 'job-opportunities', to: "jobs#association_jobs", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != '6d4d48ec'}, via: [:get]
  end

  root to: 'pages#home'
  
  get 'pricing', to: 'pages#pricing'
  get 'features', to: 'pages#features'
  get 'contact', to: "pages#contact"
  get 'demo', to: "pages#demo"
  get 'privacy', to: "pages#privacy"
  get 'association_portal', to: "pages#association_portal"

  get 'features/plan-hiring-process', to: 'features#plan_hiring_process'
  get 'features/screen-applicants', to: 'features#screen_applicants'
  get 'features/source-applicants', to: 'features#source_applicants'
  get 'features/manage-evaluate', to: 'features#manage_evaluate'
  get 'features/company-management', to: 'features#company_management'

  resources :contact_messages, only: [:new, :create]
  resources :demos, only: [:new, :create]
  resources :interview_invitations, only: [:show]
  resources :interviews
  
  get '/schedule_interview/:token', to: 'interviews#new', as: 'schedule_interview'
  post '/schedule_interview/:token', to: 'interviews#create'
  get '/booked/:id', to: "interviews#show"

  resources :job_boards
  
  resources :jobs do 
    resources :applications, only: [:new, :create]
    resources :candidates, only: [:new, :create]
    resources :questions, only: [:index]
    get '/apply', to: 'candidates#new'
    post '/apply', to: 'candidates#create'
  end
  
  get '/company-signup', to: 'companies#new'
  post '/company-signup', to: 'companies#create'

  resources :companies do 
    resources :jobs
  end
  resources :users, only: [:new, :create]
  resources :skills 
  resources :certifications

  get 'login', to: "sessions#new"
  get '/job_seeker_signup', to: 'users#new_job_seeker'
  get '/company/sign_up', to: 'users#new_company'
  post '/job_seeker_signup', to: "users#create_job_seeker"
  

  match '/widgets/:action/:widget_key', via: [:get], :controller => 'widgets', :widget_key => /.*/
  
  
  post :incoming_email, to: "inbound_emails#create"
  post '/publish/google-pub-sub-messages', to: "inbound_emails#gmail_webhook"
  post '/api/watch/outlookNotification', to: "inbound_emails#outlook_webhook"
  

  post '/inbound-can/ziprecruiter', to: "inbound_candidates#ziprecruiter_webhook"
  post '/inbound-can/indeed-apply', to: "inbound_candidates#indeed_webhook"
  

  namespace :job_seeker do 
    root to: "jobs#index"
    get '/profile', to: 'users#show'
    
    resources :create_profiles
    
    resources :jobs, only: [:index, :show] do
      resources :applications, only: [:index]
      resources :candidates, only: [:create, :new]
      get '/apply', to: 'candidates#new'
      post '/apply', to: 'candidates#create'
    end

    resources :attachments
    resources :question_answers 
    resources :users
    resources :background_images
    resources :applications, only: [:create]
    resources :user_avatars 
    resources :user_certifications
    resources :educations
    resources :projects
    
    resources :user_skills do 
      collection do 
        get :autocomplete
      end
    end

    resources :work_experiences do
      resources :accomplishments
      resources :user_skills
      resources :references
    end  
  end
  
  namespace :business do 
    root to: "jobs#index" 
    get "hiring_defaults", to: 'rejection_reasons#index'
    resources :notifications
    resources :activities
    resources :assessments
    resources :scorecards
    resources :answers
    resources :subsidiaries
    resources :hiring_teams
    resources :permissions
    resources :media_photos
    resources :team_members
    resources :logos
    resources :background_images
    resources :analytics
    resources :orders
    resources :order_items
    resources :conversations
    resources :notifications
    resources :rejection_reasons
    resources :invitations
    resources :locations 
    resources :application_emails
    resources :stage_actions
    resources :job_templates
    resources :interview_kit_templates
    resources :assessment_templates
    resources :scorecard_templates
    resources :email_templates
    
    get 'interview_kit/:id', to: "completed_assessments#interview_kit", as: 'interview_kit'
    
    get 'change_company/:id', to: "companies#change_current_company", as: 'change_company'
    resources :completed_assessments 


    resources :rooms do 
      collection do
        get "availability/:id", to: "rooms#get_availability"
      end
    end

    post "update_password", to: 'users#update_password'
    post 'create_subscription', to: 'users#create_subscription'

    resources :tasks do 
      collection do 
        get :search
        get :new_multiple, to: "tasks#new_multiple"
        post :completed, to: "tasks#completed"
        post :create_multiple, to: "tasks#create_multiple"
      end
    end

    resources :interviews do 
      collection do 
        get :search
      end
    end

    resources :companies do 
      resources :tasks
    end

    resources :interview_invitations do 
      collection do 
        get :availability, to: "interview_invitations#get_availability"
        get :new_multiple, to: "interview_invitations#new_multiple" 
        post :multiple_messages, to: "interview_invitations#multiple_messages"
      end
    end

    resources :tags do
      collection do 
        get :new_multiple, to: "tags#new_multiple" 
      end
    end

    resources :messages do
      collection do 
        get :new_multiple, to: "messages#new_multiple" 
        post :multiple_messages, to: "messages#multiple_messages"
      end
    end
    
    resources :comments do
      collection do 
        get :new_multiple, to: "comments#new_multiple"
        post :add_note_multiple, to: "comments#add_note_multiple"
      end
    end

    resources :default_stages do 
      collection do
        post :sort, to: "default_stages#sort"
      end 
    end

    resources :client_contacts do
      resources :messages
      resources :comments
      resources :tasks
      resources :activities
    end

    resources :clients do 
      collection do 
        get :search
        get :autocomplete
      end

      resources :jobs, except: [:index, :show]

      get 'jobs', to: "jobs#client_jobs"
      resources :activities
      resources :comments, except: [:index]
      get :comments, to: "comments#client_comments"
      
      resources :tasks, except: [:index, :show] do 
        collection do 
          post :completed, to: "tasks#completed"
          post :create_multiple, to: "tasks#create_multiple"
        end
      end

      get "tasks", to: "tasks#client_tasks"

      resources :client_contacts do
        resources :messages
        resources :comments
        resources :tasks
        resources :activities
      end
    end
    
    resources :users do 
      resources :email_signatures
      resources :user_avatars
      
      collection do 
        get "availability/:id", to: "users#get_availability"
        get :autocomplete
        get :search
      end
    end

    resources :job_board_rows do 
      collection do
        post :sort, to: "job_board_rows#sort"
      end 
    end
    resources :job_boards do
      resources :job_board_headers
      
    end
   
    resources :candidates do
      member do 
        get :evaluations, to: "candidates#application_form"
        get :scorecards, to: "candidates#scorecards"
        post :ratings, to: "candidates#ratings"
        get :evaluations, to: "applications#application_form"
      end

      get 'show_project', to: "candidates#show_project"
      resources :interview_invitations
      resources :work_experiences
      resources :interviews 
      resources :activities
      resources :applications 

      resources :messages
      resources :comments
      resources :resumes
      resources :tags
      resources :tasks 

      get :application_form, to: "candidates#application_form"
      # get :application_activity, to: "activities#application_activity"
      get :new_assessment, to: "assessments#new_assessment"
      post :create_from_template, to: "assessments#create_from_template"

      
      resources :application_scorecards
      resources :assessments
      resources :questionairres

      collection do 
        get :autocomplete
        get :search
        get :confirm_destroy, to: "candidates#confirm_destroy"
        post :destroy_multiple, to: "candidates#destroy_multiple"
      end
    end
    
    resources :applications do 
      member do 
        get :stage, to: "applications#stage"
        post :reject, to: "applications#reject"
        post :next_stage, to: "applications#next_stage"
        post :move_stage, to: "applications#move_stage"
        
        get :evaluations, to: "applications#application_form"
        get :scorecards, to: "applications#scorecards"
      end

      
      get :new_assessment, to: "assessments#new_assessment"
      post :create_from_template, to: "assessments#create_from_template"

      
      resources :questionairres
      resources :assessments
      
      collection do 
        get :quick_screen, to: "applications#quick_screen"
        get :confirm_destroy, to: "candidates#confirm_destroy"
        get :search, to: "applications#search"
        post :destroy_multiple, to: "candidates#destroy_multiple"
        get :multiple_change_stages, to: "applications#multiple_change_stages"
        get :new_multiple, to: "applications#new_multiple" 
        post :create_multiple, to: "applications#create_multiple"
        post :move_stage, to: "applications#move_stage"
      end
    end

    get "plan", to: "customers#plan"

    resources :customers do
      collection do 
        get 'cancel', to: "customers#cancel"
        post "new_plan", to: "customers#new_plan"
        post :create_plan, to: "customers#create_plan"
        post :update_plan, to: "customers#update_plan"
        post :cancel_subscription, to: "customers#cancel_subscription"
      end
    end
    
    resources :jobs do 
      collection do 
        get :autocomplete
        get :search
      end
      
      resources :job_feeds 
      resources :comments, except: [:index]
      resources :interviews, except: [:index]
      resources :interview_invitations, except: [:index] 
      resources :candidates
      resources :hiring_teams 
      
      resources :applications do 
        collection do 
          get :search, to: "applications#search"
          get :quick_screen, to: "applications#quick_screen"
        end
        member do 
          get :change_application, to: "applications#change_application"
        end
      end
      resources :questions do 
        collection do
          post :sort, to: "questions#sort"
        end 
      end
      
      resources :scorecards

      get :premium_boards, to: "job_feeds#premium_boards"
      get :advertise, to: "job_feeds#index"
      get 'tasks', to: "tasks#job_tasks"
      get 'comments', to: "comments#job_comments"
      get "/activities", to: 'activities#job_activity'
      
      get 'interviews', to: 'interviews#job_interviews'
      get 'interview_invitations', to: 'interview_invitations#job_invitations'
      
      resources :tasks, except: [:index, :show] do 
        collection do 
          post :create_multiple, to: "tasks#create_multiple"
        end
      end

      resources :applications do
        resources :application_scorecards
      end

      resources :stages do 
        collection do
          post :sort, to: "stages#sort"
        end 
      end
    end 

    get 'invite_user', to: 'invitations#new'
    get '/signout', to: 'sessions#destroy'
  end

  get "/auth/:provider/callback", to: 'business/users#show'
  get "/authorize", to: 'business/users#show'
  get "/authorize_room", to: 'business/rooms#outlook_token'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'  
  
  get 'register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  

  

  get 'forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  get 'expired_token', to: "password_resets#expired_token"
  resources :password_resets, only: [:show, :create]


  namespace :admin, constraints: Constraint::AdminConstraint.new do 
    root to: "jobs#index" 
    mount Sidekiq::Web, at: '/sidekiq'

    resources :users
    resources :candidates
    resources :customers
    resources :blogs
    resources :premium_boards
    resources :free_boards
    
    resources :jobs do 
      collection do 
        post :verified, to: "jobs#verified"
      end
      resources :applications
      resources :candidates
      resources :comments
      resources :tasks
      resources :activities
    end

    resources :companies do 
      resources :users
      resources :candidates
      get 'jobs', to: "jobs#company_jobs"

      collection do 
        post :verified, to: "companies#verified"
      end
    end
  end
  
  get 'adzuna-job-feed', to: "job_feeds#adzuna_job_feed"
  get 'eluta-job-feed', to: "job_feeds#eluta_job_feed"
  get 'ziprecruiter-job-feed', to: "job_feeds#ziprecruiter_job_feed"
  get 'ziprecruiter-premium-feed', to: "job_feeds#ziprecruiter_premium_feed"
  get 'trovit-job-feed', to: "job_feeds#trovit_job_feed"
  get 'jobinventory-job-feed', to: "job_feeds#job_inventory_feed"
  get 'indeed-job-feed', to: "job_feeds#indeed_job_feed"
  get 'juju-job-feed', to: "job_feeds#juju_job_feed"
  get 'neuvoo-job-feed', to: "job_feeds#neuvoo_job_feed"
  get 'jooble-job-feed', to: "job_feeds#jooble_job_feed"

  mount StripeEvent::Engine, at: '/stripe_events'
end
