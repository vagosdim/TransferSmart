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
  resources :personal_infos
  resources :recipient_infos
  get '/personal_info', to: 'personal_infos#new'
  get '/recipient_info', to: 'recipient_infos#new'
  get '/transfer_summary', to: 'transfers#edit'
  
end
