Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/contact', to: 'static_pages#contact'
  get '/signup',   to: 'users#new'
  get '/login',    to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  delete '/logout',to: 'sessions#destroy'


  post '/create_transfer', to: 'transfers#create'
  get '/exchange_info', to: 'exchange_infos#new'

  resources :users
  resources :transfers
  resources :exchange_infos
end
