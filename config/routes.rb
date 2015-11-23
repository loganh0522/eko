Rails.application.routes.draw do
  root to: "job_postings#index"

  get 'ui(/:action)', controller: 'ui'
  get 'ui/home', to: 'ui#home'

  resources :users

  namespace :business do 
    root to: "job_postings#index"
    resources :job_postings
    resources :locations 

    resources :subsidiaries do 
      resources :locations
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
