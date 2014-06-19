Cliq::Application.routes.draw do
  resources :location_suggestions

  root to: 'pages#home'



  resources :locations, only: [:index]
  resources :messages, only: [:index, :show]
  
  get '/events/upcoming', to: 'events#upcoming', as: 'upcoming_events'
  get '/events/going', to: 'events#going', as: 'going_events'
  get '/events/past', to: 'events#past', as: 'past_events'
  resources :events, only: [:index, :show]
  


  resources :users do 
    resources :events, only: [:new, :create]
    get '/events/:id/accept', to: 'events#accept', as: 'accept'
    get '/events/:id/pass', to: 'events#pass', as: 'pass'
    get '/conversations/:id/searched', to: 'conversations#searched_show', as: 'searched_convo'
    get '/chat', to: 'conversations#chat', as: 'chat'
  end

  resources :activities, only: [:index]


  get '/users/:id/activate/:code', to: 'users#activate'
  get '/search', to: 'users#search', as: 'search'
  post '/search', to: 'users#search_results'


  
  resources :partners, only: [:show]



  resources :conversations, only: [:show] do 
    resources :messages, only: [:create]
  end


  resources :partners
  resources :activities

  get '/auth/facebook/callback', :to => 'sessions#create'
  get '/auth/failure', :to => 'sessions#failure'
  get '/logout', :to => 'sessions#destroy'
end
