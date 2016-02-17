Rails.application.routes.draw do
  
  
  resources :job_boards
  
  match '/', to: "job_boards#index", constraints: {subdomain: /.+/}, via: [:get, :post, :put, :patch, :delete]
  match 'login', to: "sessions#subdomain_new", constraints: {subdomain: /.+/}, via: [:get]
  match 'login', to: "sessions#create", constraints: {subdomain: /.+/}, via: [:post]
  match 'register', to: "users#sub_new_job_seeker", constraints: {subdomain: /.+/}, via: [:get, :post, :put, :patch, :delete]
  match 'profile', to: "profiles#index", constraints: {subdomain: /.+/}, via: [:get, :post, :put, :patch, :delete]

  get 'login', to: "sessions#new"

  get 'ui(/:action)', controller: 'ui'
  get 'ui/home', to: 'ui#home'
  
  resources :users
  get '/job_seekers/new', to: 'users#new_job_seeker'
  get '/account/new', to: 'companies#new'
  
  root to: 'pages#home'

  

  namespace :job_seeker do 
    resources :jobs
    resources :profiles
    resources :work_experiences
    resources :applications, only: [:create]
  end

  namespace :business do 
    root to: "jobs#index" 

    resources :comments  
    resources :users
    resources :invitations
    resources :locations   
    resources :customers
    resources :job_boards
    

    
    resources :jobs do 
      resources :applications do
        resources :comments
        post :move_stages
      end
      resources :applicants
      resources :hiring_teams
      resources :questionairres
      
      resources :stages do 
        collection do
          post :sort
        end 
      end

    end
    
    get 'invite_user', to: 'invitations#new'
    get '/signout', to: 'sessions#destroy'

    resources :subsidiaries do 
      resources :locations
      get 'location/new', to: 'locations#new_for_subsidiary', as: 'new_location'
    end  
  end

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'
  
  get 'register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  get 'expired_token', to: "password_resets#expired_token" 
  

  
  resources :jobs
  resources :companies
end
