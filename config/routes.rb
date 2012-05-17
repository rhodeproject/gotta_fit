GottaFit::Application.routes.draw do
  get "static_pages/home"
  get "static_pages/help"
  get "static_pages/about"
  get "users/new"

  root to: 'static_pages#home'
end
