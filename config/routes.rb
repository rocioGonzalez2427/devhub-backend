Rails.application.routes.draw do
  # GraphQL endpoint
  get "up", to: "rails/health#show", as: :rails_health_check

  post "/graphql", to: "graphql#execute"

  resources :projects
  resources :tasks
  get "my_tasks", to: "tasks#my_tasks"

  get    "login",  to: "sessions#new"
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  mount Admin::Engine, at: "/admin"

  root "projects#index"

  namespace :api do
    post   "login",        to: "sessions#create"   # Api::SessionsController#create
    delete "logout",       to: "sessions#destroy"  # Api::SessionsController#destroy
    get    "current_user", to: "sessions#current"  # Api::SessionsController#current
  end

end
