Cliq::Application.routes.draw do
  root to: 'pages#home'

  resources :users do 
    resources :events, only: [:new, :create]
    get '/events/:id/accept', to: 'events#accept', as: 'accept'
    get '/events/:id/pass', to: 'events#pass', as: 'pass'
  end

  get '/users/:id/activate/:code', to: 'users#activate'
  get '/search', to: 'users#search', as: 'search'



  resources :messages, only: [:index, :show]
  resources :events, only: [:index]
  resources :partners, only: [:show]

  resources :conversations do 
    resources :messages, only: [:create]
  end


  resources :partners
  resources :activities

  get '/auth/facebook/callback', :to => 'sessions#create'
  get '/auth/failure', :to => 'sessions#failure'
  get '/logout', :to => 'sessions#destroy'
end
