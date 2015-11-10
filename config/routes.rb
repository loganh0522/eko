Rails.application.routes.draw do
  root to: "job_postings#index"

  get 'ui(/:action)', controller: 'ui'
  get 'ui/home', to: 'ui#home'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get 'Sign Out' to: 'sessions#destroy'
  resources :job_postings
  resources :users
  resources :companies 
end
