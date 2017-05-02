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



  namespace :business do 
    root to: "jobs#index" 
    resources :activities
    resources :hiring_teams
    resources :companies
    resources :messages
    resources :clients do 
      resources :client_contacts do
        resources :messages
        resources :comments
      end
    end
    
    resources :users do 
      resources :email_signatures
      resources :user_avatars
    end
    
    resources :invitations
    resources :locations 
    
    
    resources :job_boards do
      resources :job_board_headers
      resources :job_board_rows
    end

    resources :tags
    resources :notifications
    resources :interviews
    resources :email_templates
    
    get 'templates', to: "email_templates#index"
    
    resources :candidates do 
      resources :messages
      resources :comments
      resources :tags
    end
    
    resources :applications do 
      resources :ratings
      collection do 
        post :update_multiple, to: "stages#update_multiple"
        post :add_note_multiple, to: "comments#add_note_multiple"
        post :send_multiple_messages, to: "messages#send_multiple_messages"
        post :change_stage, to: "applications#change_stage"
        post :add_tag_multiple, to: "tags#add_tags_multiple_applications"
      end
    end

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
      resources :applications do
        get :application_activity, to: "activities#application_activity"
        resources :messages
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
        get :reject   
      end
      
      resources :hiring_teams do    
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
