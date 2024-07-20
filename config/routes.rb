Rails.application.routes.draw do
  root 'welcome#index'

  get 'login', to: 'sessions#new'  # 追記
  post 'login', to: 'sessions#create'  # 追記
  get 'logout', to: 'sessions#destroy'  #
  delete 'logout', to: 'sessions#destroy'  #
  resources :users, only: [:new, :create, :destroy]
    # サインアップ関連のルーティング（仮定）
  get 'signup', to: 'users#new', as: :signup
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
