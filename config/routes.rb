Trainbuddy::Application.routes.draw do

  resources :users, except: [:create]
  resources :profiles, only: [:edit, :update]
  resources :plans, except: [:index, :show]

  resources :sessions, only: [:new, :create, :destroy]
  resources :microposts, only: [:create, :destroy, :index, :new]
  resources :mails
  resources :activities, only: [:show]

  resources :invitations, only: [:new, :create, :edit, :update, :show]


  # resources :relationships,p only: [:create, :destroy, :update]
  resources :relationships, only: [:updates, :index] do
      put :updates, on: :collection
  end

  resources :broadcasts, only: [:index, :destroy]
  resources :stations, only: [:index]


  
  get "map/index"
  
  get "pages/help"
  get "pages/home"
  get "pages/contact"
  get "pages/about"
  
  get '/u/:login',  to: 'users#show',    constraints: { login: /[a-z][a-z0-9]*(_|.){1}[a-z0-9]+/i }
  
  get '/signup',    to:   'users#new'
  get '/signin',    to:   'sessions#new'
  match '/signout', to:   'sessions#destroy',   via:  :delete
   

  get '/contact',   to:   'pages#contact'
  get '/about',     to:   'pages#about'
  get '/help',      to:   'pages#help'
  get '/feeds',     to:   'pages#home'
  get '/',          to:   'map#index'
  root              to:   'map#index'

end
