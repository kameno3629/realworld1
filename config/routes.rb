Rails.application.routes.draw do
  root 'home#index'

  scope :api, defaults: { format: :json } do
    devise_for :users, controllers: { sessions: :sessions },
                       path_names: { sign_in: :login }

    # ユーザー新規作成のルート
    post 'users', to: 'users#create'
    # ユーザーログインのルート
    post 'users/login', to: 'users#login'
    resource :user, only: [:show, :update]

    resources :profiles, param: :username, only: [:show] do
      resource :follow, only: [:create, :destroy], controller: 'profiles/follows'  # フォロー/アンフォローのコントローラを指定
    end

    resources :articles, param: :slug, except: [:edit, :new] do
      resource :favorite, only: [:create, :destroy]
      resources :comments, only: [:create, :index, :destroy]
      get :feed, on: :collection
    end

    resources :tags, only: [:index] # タグの一覧を取得するルート

    # Expressのルーティングに相当する部分
    # タグコントローラー
    resources :tags, only: [:index, :create, :destroy, :update]
    # 記事コントローラー
    resources :articles do
      resources :comments, only: [:create, :index, :destroy]
      member do
        post :favorite
        delete :unfavorite
      end
    end
    # プロファイルコントローラー
    resources :profiles, only: [:show, :update] do
      member do
        post :follow
        delete :unfollow
      end
    end
    # 認証コントローラー
    post 'register', to: 'auth#register'
    post 'login', to: 'auth#login'
    delete 'logout', to: 'auth#logout'
  end
end