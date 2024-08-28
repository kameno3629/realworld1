class UsersController < ApplicationController
  # 新規作成とログインを除くアクションでユーザー認証を要求
  before_action :authenticate_user!, except: [:create, :login]

  # ユーザー新規作成アクション
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ユーザーログインアクション
  def login
    @user = User.find_by(email: user_params[:email])
    if @user&.authenticate(user_params[:password])
      # トークン発行やセッション管理などの処理をここに記述
      render json: @user
    else
      render json: { errors: ['Invalid email or password'] }, status: :unauthorized
    end
  end

  # 現在のユーザー情報を取得
  def show
    render json: current_user
  end

  # 現在のユーザー情報を更新
  def update
    if current_user.update(user_params)
      render json: current_user
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # 許可されたパラメータの定義
  def user_params
    params.require(:user).permit(:username, :email, :password, :bio, :image)
  end
end
