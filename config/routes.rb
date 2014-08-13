Cliq::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :location_suggestions

  root to: 'pages#home'
  ['help', 'contact', 'faq', 'about', 'terms'].each do |page|
    get "/#{page}", to: ("pages#" + "#{page}"), as: page 
  end

  get '/categories/:id/select', to: 'categories#select', as: 'choose_cat'
  get '/tutorial', to: 'categories#tutorial', as: 'tutorial'
  post '/tutorial_select', to: 'categories#tutorial_select', as: 'tutorial_select'

  resources :categories, only: [:index, :show] do 
    get '/choose', to: 'activities#choose', as: 'choose_activity'
  end


  resources :interests, only: [:create, :destroy]
  post '/interests/quick_create', to: 'interests#quick_create', as: 'quick_create' 
  
  resources :locations, only: [:index]
  
  resources :messages, only: [:index, :show]
  
  get '/events/upcoming', to: 'events#upcoming', as: 'upcoming_events'
  get '/events/going', to: 'events#going', as: 'going_events'
  get '/events/past', to: 'events#past', as: 'past_events'
  get '/events/open', to: 'events#open', as: 'open_events'
  get '/events/public/new', to: 'events#public_new', as: 'public_events'
  get '/events/:id/chat', to: 'events#chat', as: 'event_chat'
  post '/events', to: 'events#public_create', as: 'public_events_create'
  resources :events, only: [:index, :show]
  resources :users do 
    resources :events, only: [:new, :create]
    get '/events/:id/accept', to: 'events#accept', as: 'accept'
    get '/events/:id/pass', to: 'events#pass', as: 'pass'
    get '/conversations/:id/searched', to: 'conversations#searched_show', as: 'searched_convo'
    get '/chat', to: 'conversations#chat', as: 'chat'
  end

  get '/users/:id/block', to: 'users#block', as: 'block_user'
  get '/users/:id/other', to: 'users#other', as: 'other_user'
  get '/users/:id/settings', to: 'users#settings', as: "settings"
  post '/users/invite_friends', to: 'users#invite_friends', as: "invite_friends"
  post '/users/welcome', to: 'users#welcome_update', as: 'welcome_update'
  get '/users/:id/result_info', to: 'users#result_info', as: 'result_info'

  
  resources :activities, only: [:index, :create]
  post '/users/:id/send_activation', to: 'users#send_activation', as: 'send_activation'
  get '/users/:id/activate/:code', to: 'users#activate', as: 'activate'
  get '/search', to: 'users#search', as: 'search'
  get '/main', to: 'users#main', as: 'main'
  post '/search', to: 'users#search_results'
  post '/feedback', to: 'users#feedback', as: 'feedback'
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
