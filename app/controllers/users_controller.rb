class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]  # new と create アクションを除外

  def new
    @user = User.new
    render 'signup/signup'  # 明示的に signup/signup.html.erb をレンダリング
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in(@user)  # Deviseのヘルパーメソッドを使用
      redirect_to root_path, notice: 'ユーザー登録が完了しました。'
    else
      render :new
    end
  end

  def show
  end

  def update
    if current_user.update(user_params)
      render :show
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :bio, :image)
  end
end
