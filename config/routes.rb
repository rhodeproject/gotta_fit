GottaFit::Application.routes.draw do

  get "slots/new"

  get "slots/edit"

  get "slots/create"

  get "slots/destroy"

  get "slots/index"

  resources :sessions, only: [:new, :create, :destroy]
  resources :users
  resources :slots

  get "static_pages/help"
  get "static_pages/about"

  root to: 'static_pages#home'
  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
  match '/user/:id/confirm/:confirm_code', to:'users#confirm'
  match '/schedule',  to: 'slots#index'

end
