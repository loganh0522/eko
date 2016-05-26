Rails.application.routes.draw do
  
  root to: 'pages#home'
  
  resources :job_boards
  resources :jobs
  resources :companies

  match '/', to: "job_boards#index", constraints: {subdomain: /.+/}, via: [:get, :post, :put, :patch, :delete]
  match 'login', to: "sessions#subdomain_new", constraints: {subdomain: /.+/}, via: [:get]
  match 'login', to: "sessions#create", constraints: {subdomain: /.+/}, via: [:post]
  match 'job', to: "jobs#show", constraints: {subdomain: /.+/}, via: [:get, :post, :put, :patch, :delete]
  match 'register', to: "users#sub_new_job_seeker", constraints: {subdomain: /.+/}, via: [:get, :post, :put, :patch, :delete]
  match 'profile', to: "profiles#index", constraints: {subdomain: /.+/}, via: [:get, :post, :put, :patch, :delete]



  get 'login', to: "sessions#new"

  get 'ui(/:action)', controller: 'ui'
  get 'ui/home', to: 'ui#home'
  
  resources :users
  get '/job_seekers/new', to: 'users#new_job_seeker'
  get '/account/new', to: 'companies#new'
  
  

  

  namespace :job_seeker do 
    resources :jobs
    resources :profiles 
    resources :educations
    resources :work_experiences
    resources :accomplishments
    resources :applications, only: [:create]
    resources :question_answers
    resources :users
  end

  namespace :business do 
    root to: "jobs#index" 

    resources :users
    resources :invitations
    resources :locations 
    get "plan", to: "customers#plan"  
    
    resources :customers do
      collection do 
        get 'cancel', to: "customers#cancel"
        post "update_plan", to: "customers#update_plan"
        post "cancel_subscription", to: "customers#cancel_subscription"
      end
    end

    resources :job_boards
    resources :applications

    
    resources :jobs do 
      
      resources :applications do
        collection do 
          post :update_multiple, to: "stages#update_multiple"
          post :add_note_multiple, to: "comments#add_note_multiple"
          post :send_multiple_messages, to: "messages#send_multiple_messages"
        end
        
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
      
      resources :hiring_teams
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
  get 'expired_token', to: "password_resets#expired_token"   
end
