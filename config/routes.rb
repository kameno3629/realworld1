Rails.application.routes.draw do
  scope :api, defaults: { format: :json } do
    devise_for :users, controllers: { sessions: :sessions },
                       path_names: { sign_in: :login }

    resource :user, only: [:show, :update]

    resources :profiles, param: :username, only: [:show] do
      resource :follow, only: [:create, :destroy]
    end

    resources :articles, param: :slug, except: [:new, :edit] do
      resource :favorite, only: [:create, :destroy]
      resources :comments, only: [:create, :index, :destroy]
      get :feed, on: :collection
    end

    resources :tags, only: [:index]
  end

  # ホームページへのルート
  root 'home#index'
  
  # 追加: 単数形のルートが必要な場合
  get '/article/:slug', to: 'articles#show', as: :article_show

  # newアクションのルート
  get '/articles/new', to: 'articles#new', as: :new_article

  # editアクションのルート
  get '/articles/:slug/edit', to: 'articles#edit', as: :edit_article
end