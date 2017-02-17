Rails.application.routes.draw do
  post '/rate' => 'rater#create', :as => 'rate'
  match '/', to: "job_boards#index", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != '7c1aba01'}, via: [:get, :post, :put, :patch, :delete]
  match 'login', to: "sessions#subdomain_new", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != '7c1aba01'}, via: [:get]
  match 'login', to: "sessions#create", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != '7c1aba01'}, via: [:post]
  match 'jobs/:id', to: "jobs#show", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != '7c1aba01'}, via: [:get, :post, :put, :patch, :delete]
  match 'register', to: "users#sub_new_job_seeker", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != '7c1aba01'}, via: [:get, :post, :put, :patch, :delete]
  match 'profile', to: "profiles#index", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != '7c1aba01'}, via: [:get, :post, :put, :patch, :delete]
  match 'create-profile', to: "profiles#create_profile", constraints: lambda {|r| r.subdomain.present? && r.subdomain != 'www' && r.subdomain != 'prod-talentwiz' && r.subdomain != 'dev-talentwiz' && r.subdomain != 'staging-talentwiz' && r.subdomain != '7c1aba01'}, via: [:get, :post, :put, :patch, :delete]

  root to: 'pages#home'
  
  get 'pricing', to: 'pages#pricing'
  get 'features', to: 'pages#features'
  get 'create-profile', to: "profiles#create_profile"
  get 'features/plan-hiring-process', to: 'features#plan_hiring_process'


  get 'features/branded-job-board', to: 'features#job_board'
  get 'features/applicant-tracking', to: 'features#applicant_tracking'
  get 'features/candidate-profile', to: 'features#candidate_profile'
  get 'features/talent-pool', to: 'features#talent_pool'
  get 'features/hiring-team', to: 'features#hiring_team'
  get 'features/recruitment-pipeline', to: 'features#recruitment_pipeline'
  get 'features/evaluate-candidate', to: 'features#evaluate_candidate'
  get 'features/task-pipeline', to: 'features#task_pipeline'
  get 'features/user-roles', to: 'features#user_roles'
  get 'features/manage-interviews', to: 'features#manage_interviews'
  get 'features/centralized-communication', to: 'features#centralized_communication'
  get 'features/score-assess', to: 'features#score_assess'

  resources :job_boards
  resources :jobs
  resources :companies
  resources :users

  get 'login', to: "sessions#new"
  get '/job_seekers/new', to: 'users#new_job_seeker'
  get '/account/new', to: 'companies#new'
  
  match '/widgets/:action/:widget_key', via: [:get], :controller => 'widgets', :widget_key => /.*/
  
  post :incoming_email, to: "inbound_emails#create"

  resources :skills 
  resources :certifications

  namespace :job_seeker do 
    root to: "jobs#index"
    resources :jobs, only: [:index, :show]
    resources :profiles, only: [:index]
    resources :user_certifications
    resources :user_skills
    resources :educations
    resources :work_experiences
    resources :accomplishments
    resources :applications, only: [:create]
    resources :question_answers
    
    get "create_profile", to: "users#create_profile"

    resources :users do
      get "add_skills", to: "users#add_skills"
      delete "delete_skill", to: "users#delete_skill"
      get "add_certifications", to: "users#add_certifications"
    end

    resources :user_avatars   

    post "update_skills", to: "users#update_skills"
    post "update_certification", to: "users#update_certifications"
  end

  get "/auth/:provider/callback", to: 'business/users#edit'

  namespace :business do 
    root to: "jobs#index" 
    resources :activities
    resources :hiring_teams
    resources :users
    resources :invitations
    resources :locations 
    resources :user_avatars
    resources :job_boards
    resources :tags
    resources :notifications
    resources :interviews
    resources :email_templates
    get 'templates', to: "email_templates#index"
    resources :applications do 
      collection do 
        post :update_multiple, to: "stages#update_multiple"
        post :add_note_multiple, to: "comments#add_note_multiple"
        post :send_multiple_messages, to: "messages#send_multiple_messages"
        post :change_stage, to: "applications#change_stage"
      end
    end

    get 'job_hiring_team', to: "hiring_teams#job_hiring_team"
    get "business/applications/filter", to: "applications#filter_applicants"
    get "business/mention_user", to: "applications#mention_user"
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
