Rails.application.routes.draw do
  root 'home#index'

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

  # 新規作成と表示のためのルーティング
  resources :articles, only: [:create]
end
