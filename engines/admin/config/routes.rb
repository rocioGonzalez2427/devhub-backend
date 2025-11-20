Admin::Engine.routes.draw do
    # Root page for the admin panel
    root to: "dashboard#index"

    # Admin projects routes
    resources :projects, only: [:index, :show]

    # Admin tasks routes
    resources :tasks, only: [:index, :show]
  end
  