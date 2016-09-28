Rails.application.routes.draw do
  root to: 'pages#home'
  get 'pricing', to: 'pages#pricing'
  get 'features', to: 'pages#features'


  resources :job_boards
  resources :jobs
  resources :companies
  resources :users

  match '/', to: "job_boards#index", constraints: {subdomain: /.+/}, via: [:get, :post, :put, :patch, :delete]
  match 'login', to: "sessions#subdomain_new", constraints: {subdomain: /.+/}, via: [:get]
  match 'login', to: "sessions#create", constraints: {subdomain: /.+/}, via: [:post]
  match 'job', to: "jobs#show", constraints: {subdomain: /.+/}, via: [:get, :post, :put, :patch, :delete]
  match 'register', to: "users#sub_new_job_seeker", constraints: {subdomain: /.+/}, via: [:get, :post, :put, :patch, :delete]
  match 'profile', to: "profiles#index", constraints: {subdomain: /.+/}, via: [:get, :post, :put, :patch, :delete]



  get 'login', to: "sessions#new"
  get '/job_seekers/new', to: 'users#new_job_seeker'
  get '/account/new', to: 'companies#new'
  
  
  map.connect '/widget/:action/:company_name', :controller => 'widget', :company_name => /.*/
  
  resources :skills 
  resources :certifications

  namespace :job_seeker do 
    resources :jobs

    resources :profiles 
    resources :user_certifications
    resources :user_skills
    resources :educations
    resources :work_experiences
    resources :accomplishments
    resources :applications, only: [:create]
    resources :question_answers
    
    resources :users do
      get "add_skills", to: "users#add_skills"
      delete "delete_skill", to: "users#delete_skill"
      get "add_certifications", to: "users#add_certifications"
    end

    resources :user_avatars   

    post "update_skills", to: "users#update_skills"
    post "update_certification", to: "users#update_certifications"
  end

  namespace :business do 
    root to: "jobs#index" 
    resources :activities
    resources :hiring_teams
    resources :users
    resources :invitations
    resources :locations 
    resources :user_avatars
    resources :job_boards
    resources :applications

    get "plan", to: "customers#plan"
    resources :customers do
      collection do 
        get 'cancel', to: "customers#cancel"
        post "new_plan", to: "customers#new_plan"
        post "create_plan", to: "customers#create_plan"
        post "update_plan", to: "customers#update_plan"
        post "cancel_subscription", to: "customers#cancel_subscription"
      end
    end
    
    resources :jobs do 
      post :close_job, to: "jobs#close_job"
      post :archive_job, to: "jobs#archive_job"
      post :publish_job, to: "jobs#publish_job"
      
      resources :applications do
        collection do 
          post :update_multiple, to: "stages#update_multiple"
          post :add_note_multiple, to: "comments#add_note_multiple"
          post :send_multiple_messages, to: "messages#send_multiple_messages"
        end

        get :application_activity, to: "activities#application_activity"
        resources :messages
        resources :comments
        resources :application_scorecards
        resources :assessments
        
        resources :scorecards do 
          collection do 
            post :my_scorecard
          end
        end  

        post :move_stages    
      end
      
      resources :hiring_teams do
        
      end

      resources :questionairres
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
