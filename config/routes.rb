Rails.application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get 'ui/home', to: 'ui#home'
end
