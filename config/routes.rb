Rails.application.routes.draw do
  get 'shuffled_overviews/create'
  root 'welcome#index'

  get 'login', to: 'sessions#new'  # 追記
  post 'login', to: 'sessions#create'  # 追記
  get 'logout', to: 'sessions#destroy'  #
  delete 'logout', to: 'sessions#destroy'  #
  resources :users, only: [:new, :create, :destroy]
    # サインアップ関連のルーティング（仮定）
  get 'signup', to: 'users#new', as: :signup
  get 'settings', to: 'users#show', as: :settings
  get 'profile', to: 'users#profile', as: :profile
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resource :avatar, only: [:edit, :update]

  resources :follows, only: [:create, :destroy]
  resource :users, only: [] do
    member do
      get 'edit_password', to: 'users#edit_password'
      patch 'update_password', to: 'users#update_password'
    end
  end

  get 'related_movies/:id', to: 'related_movies#show', as: 'related_movie'
  get 'shuffled_overview', to: 'related_movies#show_shuffled_overview', as:'shuffled_overview'
  
  resources :shuffled_overviews, only: [:index], defaults: { format: 'html' }
  
  resources :users do
    get 'my_shuffled_overviews', to: 'shuffled_overviews#my_shuffled_overviews', on: :member
    resources :shuffled_overviews, only: [:show, :update]
    resources :shuffled_overviews, only: [:show] do
      post 'bookmarks', to: 'bookmark_of_shuffled_overviews#create', as: :bookmarks
      delete 'bookmarks', to: 'bookmark_of_shuffled_overviews#destroy', as: :bookmark
    end
    resources :bookmark_of_shuffled_overviews, only: [:index] do
      collection do
        get 'filter_bookmarked_overviews_by_date/:date', action: :filter_bookmarked_overviews_by_date, as: :filter_bookmarked_overviews_by_date
      end
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
    resources :related_movies do
      member do
        post 'bookmark', to: 'related_movies#bookmark', as: :bookmark_of_related_movie
        delete 'unbookmark', to: 'related_movies#unbookmark', as: :unbookmark_of_related_movie
      end
    end
    resources :bookmark_of_movies, only: [:index]
    resources :bookmark_of_movies, only:[] do
      collection do
        get 'filter_bookmarked_movies_by_date/:date', action: :filter_bookmarked_movies_by_date, as: :filter_bookmarked_movies_by_date
      end
    end
    resources :movies, only: [:show] do
      post 'bookmark', to: 'bookmark_of_movies#bookmark', as: :bookmark_movie
      delete 'unbookmark', to: 'bookmark_of_movies#unbookmark', as: :unbookmark_movie
     end
  end
  
  

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
