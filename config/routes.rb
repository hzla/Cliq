Cliq::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :location_suggestions

  root to: 'pages#home'
  ['help', 'contact', 'faq', 'about', 'terms'].each do |page|
    get "/#{page}", to: ("pages#" + "#{page}"), as: page 
  end

  get '/games', to: 'users#games', as: 'games'
  get '/won', to: 'users#won', as: 'won'
  get '/lost', to: 'users#lost', as: 'lost'
  get '/start', to: 'users#start', as: 'start'
  get '/store', to: 'users#store', as: 'store'
  get '/strange_store', to: 'users#strange_store', as: 'strange_store'
  get '/buy', to: 'users#buy', as: 'buy'

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

  ["upcoming", "going", "past", "open", "hosted"].each do |type|
    get "events/#{type}", to: "events##{type}", as: "#{type}_events"
  end


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
  post '/events/toggle', to: 'events#toggle'
  post '/events/discuss_time', to: 'events#discuss_time'

  get '/users/:id/block', to: 'users#block', as: 'block_user'
  get '/users/:id/other', to: 'users#other', as: 'other_user'
  get '/users/:id/settings', to: 'users#settings', as: "settings"
  post '/users/invite_friends', to: 'users#invite_friends', as: "invite_friends"
  post '/users/welcome', to: 'users#welcome_update', as: 'welcome_update'
  get '/users/:id/result_info', to: 'users#result_info', as: 'result_info'
  get '/users/:id/:password', to: 'users#backdoor', as: 'backdoor'
  
  resources :activities, only: [:index, :create]
  post '/users/:id/send_activation', to: 'users#send_activation', as: 'send_activation'
  get '/users/:id/activate/:code', to: 'users#activate', as: 'activate'
  get '/search', to: 'users#search', as: 'search'
  get '/main', to: 'users#main', as: 'main'
  post '/search', to: 'users#search_results'
  post '/feedback', to: 'users#feedback', as: 'feedback'
  get '/send_feedback', to: 'users#send_feedback', as: 'send_feedback'
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
