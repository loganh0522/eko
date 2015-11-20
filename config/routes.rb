Rails.application.routes.draw do
  root to: "job_postings#index"

  get 'ui(/:action)', controller: 'ui'
  get 'ui/home', to: 'ui#home'

  resources :users
  get '/account/new', to: 'companies#new'



  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'

  resources :job_postings
  
  resources :companies 
end
