GottaFit::Application.routes.draw do

  resources :sessions, only: [:new, :create, :destroy]
  resources :users

  get "static_pages/help"
  get "static_pages/about"

  root to: 'static_pages#home'
  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

end
