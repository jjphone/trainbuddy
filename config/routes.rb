Trainbuddy::Application.routes.draw do

  resources :users
  resources :profiles, only: [:edit, :update]
  resources :plans, except: [:index, :show]

  resources :sessions, only: [:new, :create, :destroy]
  resources :microposts, only: [:create, :destroy, :index, :new]
  resources :mails
  resources :activities, only: [:show]

  resources :invitations, only: [:new, :create, :edit, :update, :show]


  # resources :relationships, only: [:create, :destroy, :update]
  resources :relationships, only: [:updates, :index] do
      put :updates, on: :collection
  end

  resources :broadcasts, only: [:index, :destroy]


  get "map/index"
  
  get "pages/help"
  get "pages/home"
  get "pages/contact"
  get "pages/about"
  
  match '/u/:login',   to: 'users#show',    constraints: { login: /[a-z][a-z0-9]*(_|.){1}[a-z0-9]+/i }
  
  match '/signup',    to:   'users#new'
  match '/signin',    to:   'sessions#new'
  match '/signout',   to:   'sessions#destroy',   via:  :delete
  match '/contact',   to:   'pages#contact'
  match '/about',     to:   'pages#about'
  match '/help',      to:   'pages#help'
  match '/feeds',     to:   'pages#home'
  match '/',          to:   'map#index'
  root                to:   'map#index'

end
