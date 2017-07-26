Rails.application.routes.draw do
  post '/rate' => 'rater#create', :as => 'rate'

  if lambda {|r| r.subdomain != '69e63bf2'}
    match '/', to: "job_boards#index", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != '69e63bf2'}, via: [:get, :post, :put, :patch, :delete]
    match 'login', to: "sessions#subdomain_new", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != '69e63bf2'}, via: [:get]
    match 'login', to: "sessions#create", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != '69e63bf2'}, via: [:post]
    match 'jobs/:id', to: "jobs#show", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != '69e63bf2'}, via: [:get, :post, :put, :patch, :delete]
    match 'register', to: "users#sub_new_job_seeker", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != '69e63bf2'}, via: [:get, :post, :put, :patch, :delete]
    match 'profile', to: "profiles#index", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != '69e63bf2'}, via: [:get, :post, :put, :patch, :delete]
    match 'create-profile', to: "profiles#new", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != '69e63bf2'}, via: [:get, :post, :put, :patch, :delete]
  end

  root to: 'pages#home'
  
  get 'pricing', to: 'pages#pricing'
  get 'features', to: 'pages#features'
  get 'contact', to: "pages#contact"
  get 'demo', to: "pages#demo"


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
  end
  resources :companies
  resources :users
  resources :profiles, only: [:index, :new, :create]
  

  get 'login', to: "sessions#new"
  get '/job_seekers/new', to: 'users#new_job_seeker'
  get '/account/new', to: 'companies#new'
  
  match '/widgets/:action/:widget_key', via: [:get], :controller => 'widgets', :widget_key => /.*/
  
  post :incoming_email, to: "inbound_emails#create"

  resources :skills 
  resources :certifications

  namespace :job_seeker do 
    root to: "jobs#index"
    resources :jobs, only: [:index, :show] do
      resources :applications
    end
    resources :users do 
      resources :user_avatars 
    end

    resources :profiles do 
      resources :user_certifications
      resources :educations
      resources :work_experiences do
        resources :accomplishments
        resources :user_skills
        resources :references
      end
    end

    resources :applications, only: [:create]
    resources :question_answers     
  end

  get "/auth/:provider/callback", to: 'business/users#edit'

  get "/authorize", to: 'business/users#outlook_get_token'
  get "/authorize_room", to: 'business/rooms#outlook_token'
  namespace :business do 
    root to: "jobs#index" 
    get "hiring_defaults", to: 'rejection_reasons#index'
    resources :activities
    resources :hiring_teams
    resources :interview_invitations
    resources :rooms
    resources :tasks
    resources :rejection_reasons
    resources :invitations
    resources :locations 
    resources :application_emails
    resources :tags
    resources :notifications
    resources :interviews
    resources :email_templates

    resources :companies do 
      resources :tasks
    end

    resources :messages do
      collection do 
        post :multiple_messages, to: "messages#multiple_messages"
      end
    end
    
    resources :comments do
      collection do 
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
      resources :jobs
      resources :activities
      resources :comments
      resources :tasks
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
    end
  
    resources :job_boards do
      resources :job_board_headers
      resources :job_board_rows
    end
   
    get 'templates', to: "email_templates#index"
    
    resources :candidates do
      resources :interviews
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
      resources :ratings
      resources :comments
      resources :tasks
      resources :messages
      resources :resumes
      collection do 
        post :update_multiple, to: "stages#update_multiple"
        post :change_stage, to: "applications#change_stage"
        post :add_tag_multiple, to: "tags#add_tags_multiple_applications"
      end
    end

    post "candidates/filter_applicants", to: "candidates#filter_candidates"
    get 'job_hiring_team', to: "hiring_teams#job_hiring_team"
    post "applications/filter_applicants", to: "applications#filter_applicants"
    get "mention_user", to: "applications#mention_user"
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
      post :close_job, to: "jobs#close_job"
      post :archive_job, to: "jobs#archive_job"
      post :publish_job, to: "jobs#publish_job"
      get :promote, to: "jobs#promote"
      
      resources :interviews
      resources :comments
      resources :activities
      resources :tags
      resources :tasks
      resources :hiring_teams
      
      resources :applications do
        get :application_form, to: "applications#application_form"
        get :application_activity, to: "activities#application_activity"
        resources :messages
        resources :activities
        resources :comments
        resources :application_scorecards
        resources :assessments
        resources :tags       
        resources :scorecards do 
          collection do 
            post :my_scorecard
          end
        end  

        get :move_stages        
        post :reject, to: "applications#reject"
      end
      
      

      resources :questionairres do 
        resources :questions
      end

      resources :scorecards do
        resources :scorecard_sections
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

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'  
  get 'register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  
  

  get 'forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  get 'expired_token', to: "password_resets#expired_token"
  resources :password_resets, only: [:show, :create]

  
  mount StripeEvent::Engine, at: '/stripe_events'
end
