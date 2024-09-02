Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, skip: [:sessions, :registrations]

  # Deviseのスコープを定義
  devise_scope :user do
    get '/login', to: 'sessions#new', as: :login
    post '/login', to: 'sessions#create', as: :user_session
    delete '/logout', to: 'sessions#destroy', as: :logout
    get '/register', to: 'users#new', as: :register
    post '/users', to: 'users#create', as: :users
  end

  scope :api, defaults: { format: :json } do
    devise_for :users, controllers: { sessions: :sessions },
                       path_names: { sign_in: :login }

    resource :user, only: [:show, :update]

    resources :profiles, param: :username, only: [:show] do
      resource :follow, only: [:create, :destroy]
    end

    resources :articles, param: :slug, except: [:edit, :new, :show] do
      resource :favorite, only: [:create, :destroy]
      resources :comments, only: [:create, :index, :destroy]
      get :feed, on: :collection
    end

    resources :tags, only: [:index]
  end

  # 明示的に 'new' アクションのルーティングを定義
  get '/articles/new', to: 'articles#new', as: :new_article
  # スラッグを使用するためのルーティングを追加
  # 重複を避けるために名前を変更
  get '/articles/:slug', to: 'articles#show', as: :article_with_slug
end
