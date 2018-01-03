require 'sidekiq/web'

Rails.application.routes.draw do
  post '/rate' => 'rater#create', :as => 'rate'

  if lambda {|r| r.subdomain != 'd2a80095'}
    match '/', to: "job_boards#index", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != 'fefcbc53'}, via: [:get, :post, :put, :patch, :delete]
    match 'login', to: "sessions#subdomain_new", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != 'fefcbc53'}, via: [:get]
    match 'login', to: "sessions#create", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != 'fefcbc53'}, via: [:post]
    match 'jobs/:id', to: "jobs#show", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != 'fefcbc53'}, via: [:get, :post, :put, :patch, :delete]
    match 'register', to: "users#sub_new_job_seeker", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != 'fefcbc53'}, via: [:get, :post, :put, :patch, :delete]
    match 'profile', to: "profiles#index", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != 'fefcbc53'}, via: [:get, :post, :put, :patch, :delete]
    match 'create-profile', to: "profiles#new", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != 'fefcbc53'}, via: [:get, :post, :put, :patch, :delete]
  end

  root to: 'pages#home'
  
  get 'pricing', to: 'pages#pricing'
  get 'features', to: 'pages#features'
  get 'contact', to: "pages#contact"
  get 'demo', to: "pages#demo"
  get 'privacy', to: "pages#privacy"


  get 'features/plan-hiring-process', to: 'features#plan_hiring_process'
  get 'features/screen-applicants', to: 'features#screen_applicants'
  get 'features/source-applicants', to: 'features#source_applicants'
  get 'features/manage-evaluate', to: 'features#manage_evaluate'
  get 'features/company-management', to: 'features#company_management'

  resources :contact_messages, only: [:new, :create]
  resources :demos, only: [:new, :create]
  resources :interview_invitations, only: [:show]
  resources :interviews
  get 'schedule_interview/:token', to: 'interviews#show', as: 'schedule_interview'

  resources :job_boards
  resources :jobs do 
    resources :applications, only: [:index, :new, :create]
    resources :candidates, only: [:index, :new, :create]
  end
  
  get '/company-signup', to: 'companies#new'
  post '/company-signup', to: 'companies#create'

  resources :companies, only: [:new, :create]


  resources :users
  resources :profiles, only: [:index, :new, :create]
  resources :skills 
  resources :certifications

  get 'login', to: "sessions#new"
  get '/job_seeker_signup', to: 'users#new_job_seeker'
  post '/job_seeker_signup', to: "users#create_job_seeker"
  

  match '/widgets/:action/:widget_key', via: [:get], :controller => 'widgets', :widget_key => /.*/
  
  
  post :incoming_email, to: "inbound_emails#create"
  post '/publish/google-pub-sub-messages', to: "inbound_emails#gmail_webhook"
  post '/api/watch/outlookNotification', to: "inbound_emails#outlook_webhook"
  
  

  namespace :job_seeker do 
    root to: "jobs#index"
    get '/profile', to: 'users#show'
    
    resources :create_profiles
    resources :jobs, only: [:index, :show] do
      resources :applications
      resources :candidates, only: [:index, :new, :create]
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
    resources :activities
    resources :hiring_teams
    resources :rooms
    resources :media_photos
    resources :team_members
    resources :logos
    resources :background_images
    resources :analytics
    resources :orders
    resources :order_items
    resources :conversations
    resources :rejection_reasons
    resources :invitations
    resources :locations 
    resources :application_emails
    resources :notifications
    resources :interviews
    resources :email_templates

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

    resources :companies do 
      resources :tasks
    end

    resources :interview_invitations do 
      collection do 
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
        get :autocomplete
      end
    end
  
    resources :job_boards do
      resources :job_board_headers
      resources :job_board_rows
    end
   
    get 'templates', to: "email_templates#index"
    
    resources :candidates do
      collection do 
        get :autocomplete
        get :search
      end
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
      get :application_form, to: "applications#application_form"
      get :application_activity, to: "activities#application_activity"
      
      resources :application_scorecards
      resources :assessments

      collection do 
        delete :destroy_multiple, to: "candidates#destroy_multiple"
      end
    end
    
    resources :applications do 
      collection do 
        post :move_stages, to: "applications#move_stage"
        get :new_multiple, to: "applications#new_multiple" 
        post :create_multiple, to: "applications#create_multiple"
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
      
      get 'tasks', to: "tasks#job_tasks"
      get 'comments', to: "comments#job_comments"
      get "/activities", to: 'activities#job_activity'
      get :promote, to: "jobs#promote"
      get 'interviews', to: 'interviews#job_interviews'
      get 'interview_invitations', to: 'interview_invitations#job_invitations'
      
      resources :tasks, except: [:index, :show] do 
        collection do 
          post :create_multiple, to: "tasks#create_multiple"
        end
      end
      
      resources :comments, except: [:index]
      resources :interviews, except: [:index]
      resources :interview_invitations, except: [:index] 
      resources :candidates

      resources :applications do
        post :reject, to: "applications#reject"
        resources :application_scorecards
      end

      resources :hiring_teams 
      resources :questions
      resources :scorecards
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
  get "/authorize", to: 'business/users#outlook_get_token'
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
    resources :premium_boards
    resources :users
    resources :candidates
    resources :customers

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
    end
  end


  get 'adzuna-job-feed', to: "job_feeds#adzuna_job_feed"
  get 'eluta-job-feed', to: "job_feeds#eluta_job_feed"
  get 'ziprecruiter-job-feed', to: "job_feeds#ziprecruiter_job_feed"
  get 'trovit-job-feed', to: "job_feeds#trovit_job_feed"
 

  get 'juju-job-feed', to: "job_feeds#juju_job_feed"

  

  get '-job-feed', to: "job_feeds#jooble_job_feed"
  get 'jooble-job-feed', to: "job_feeds#jooble_job_feed"
  get 'jooble-job-feed', to: "job_feeds#jooble_job_feed"
  mount StripeEvent::Engine, at: '/stripe_events'
end
