Rails.application.routes.draw do
  root to: "job_postings#index"

  get 'ui(/:action)', controller: 'ui'
  get 'ui/home', to: 'ui#home'

  resources :job_postings
  resources :users
  resources :companies 
end
