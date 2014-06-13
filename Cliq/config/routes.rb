Cliq::Application.routes.draw do
  root to: 'pages#home'

  resources :users do 
    resources :events, only: [:new, :create]
  end

  get '/users/:id/activate/:code', to: 'users#activate'
  get '/search', to: 'users#search', as: 'search'



  resources :messages, only: [:index, :show]
  resources :events, only: [:index]

  resources :conversations do 
    resources :messages, only: [:create]
  end


  resources :partners
  resources :activities

  get '/auth/facebook/callback', :to => 'sessions#create'
  get '/auth/failure', :to => 'sessions#failure'
  get '/logout', :to => 'sessions#destroy'
end
