Rails.application.routes.draw do
  root to: "job_postings#index"

  get 'ui(/:action)', controller: 'ui'
  get 'ui/home', to: 'ui#home'

  resources :users

  namespace :business do 
    root to: "job_postings#index"
    resources :job_postings
    resources :locations 
    resources :users
    resources :invitations
    get 'invite_user', to: 'invitations#new'

    resources :subsidiaries do 
      resources :locations
      get 'location/new', to: 'locations#new_for_subsidiary', as: 'new_location'
    end

    get '/signout', to: 'sessions#destroy'
  end

  get '/account/new', to: 'companies#new'


  resources :job_postings
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'

  
  
  resources :companies 
end
