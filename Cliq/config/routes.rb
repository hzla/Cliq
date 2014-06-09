Cliq::Application.routes.draw do
  root to: 'pages#home'

  resources :users
  get '/users/:id/activate/:code', to: 'users#activate'
  get '/search', to: 'users#search', as: 'search'

  resources :messages, only: [:index]


  resources :partners
  resources :activities

  get '/auth/facebook/callback', :to => 'sessions#create'
  get '/auth/failure', :to => 'sessions#failure'
  get '/logout', :to => 'sessions#destroy'




end
