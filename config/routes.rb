Rails.application.routes.draw do
  root to: "sessions#new"

  get 'ui(/:action)', controller: 'ui'
  get 'ui/home', to: 'ui#home'
  
  resources :users
  get '/job_seekers/new', to: 'users#new_job_seeker'
  get '/account/new', to: 'companies#new'

  namespace :job_seeker do 
    resources :jobs
    resources :profiles
    resources :work_experiences
  end

  namespace :business do 
    root to: "jobs#index"    
    resources :users
    resources :invitations
    resources :locations   
    resources :customers

    resources :jobs do 
      resources :hiring_teams  
      resources :stages do 
        collection do
          post :sort
        end 
      resources :questionairres
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
