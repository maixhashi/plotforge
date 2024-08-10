Rails.application.routes.draw do
  get 'shuffled_overviews/create'
  root 'welcome#index'

  get 'login', to: 'sessions#new'  # 追記
  post 'login', to: 'sessions#create'  # 追記
  get 'logout', to: 'sessions#destroy'  #
  delete 'logout', to: 'sessions#destroy'  #
  resources :users, only: [:new, :create, :destroy]
  resources :settings, only: [:index, :show]
    # サインアップ関連のルーティング（仮定）
  get 'signup', to: 'users#new', as: :signup
  get 'profile', to: 'users#show', as: :profile
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resource :users, only: [] do
    member do
      get 'edit_password', to: 'users#edit_password'
      patch 'update_password', to: 'users#update_password'
    end
  end

  get 'movies/:id', to: 'movies#show', as: 'movie'
  get 'search', to: 'movies#search'
  get 'random_movie', to: 'movies#show_random'
  get 'random_multiple_movies', to: 'movies#show_multiple_random'
  get 'shuffled_overview', to: 'movies#show_shuffled_overview', as:'shuffled_overview'

  resources :users do
    resources :shuffled_overviews, only: [:show]
    resources :shuffled_overviews, only: [:show] do
      post 'bookmarks', to: 'bookmark_of_shuffled_overviews#create', as: :bookmarks
      # delete 'bookmarks/:id', to: 'bookmark_of_shuffled_overviews#destroy', as: :bookmark
      delete 'bookmarks', to: 'bookmark_of_shuffled_overviews#destroy', as: :bookmark
    end
    resources :shuffled_overviews, only: [:index, :create] do
      collection do
        get 'filter_shuffled_overviews_by_date/:date', action: :filter_shuffled_overviews_by_date, as: :filter_shuffled_overviews_by_date
      end
    end
    resources :related_movies, only: [:index, :create] do
      collection do
        get 'filter_movies_by_date/:date', action: :filter_movies_by_date, as: :filter_movies_by_date
      end
    end
  end
  

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
