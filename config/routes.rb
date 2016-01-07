Rails.application.routes.draw do
  root to: "sessions#new"

  get 'ui(/:action)', controller: 'ui'
  get 'ui/home', to: 'ui#home'

  resources :users
  resources :job_postings
  resources :companies

  namespace :business do 
    root to: "job_postings#index"
    resources :job_postings
    resources :locations 
    resources :users
    resources :invitations
    resources :customers
    get 'invite_user', to: 'invitations#new'

    resources :subsidiaries do 
      resources :locations
      get 'location/new', to: 'locations#new_for_subsidiary', as: 'new_location'
    end

    get '/signout', to: 'sessions#destroy'
  end

  get '/account/new', to: 'companies#new'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'
  
  get 'register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  get 'expired_token', to: "password_resets#expired_token" 
  
end
