Rails.application.routes.draw do
  root 'welcome#index'

  get 'shuffled_overviews/create'
  
  get 'timeline', to: 'timeline#index'
  get 'timeline/shuffled_overviews', to: 'timeline#timeline_shuffled_overviews', as: :timeline_shuffled_overviews
  get 'timeline/movies', to: 'timeline#timeline_movies', as: :timeline_movies
  resources :timeline, only: [] do
    get 'update_overviews', on: :collection
  end

  post 'tutorial_message/next', to: 'tutorial_messages#next', as: 'tutorial_message_next'
  get 'tutorial_message', to: 'tutorial_messages#show', as: 'tutorial_message'


  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  get 'settings', to: 'users#show', as: :settings

  resources :users, param: :user_id do
    member do
      get 'mypage', to: 'users#mypage', as: :mypage
      get 'mypage/shuffled_overviews', to: 'users#mypage_shuffled_overviews', as: :mypage_shuffled_overviews
      get 'mypage/bookmarked_shuffled_overviews', to: 'users#mypage_bookmarked_shuffled_overviews', as: :mypage_bookmarked_shuffled_overviews
      get 'mypage/my_movies', to: 'users#mypage_my_movies', as: :mypage_my_movies
      get 'mypage/bookmarked_my_movies', to: 'users#mypage_bookmarked_my_movies', as: :mypage_bookmarked_my_movies
      get 'mypage/notifications', to: 'users#mypage_notifications', as: :mypage_notifications
    end
    member do
      get 'movies/:movie_id', to: 'related_movies#show', as: :movie
    end
    member do
      get 'followings', to: 'follows#index_followings', as: :followings
      get 'followers', to: 'follows#index_followers', as: :followers
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resource :avatar, only: [:edit, :update]

  resources :follows, only: [:create, :destroy]

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
