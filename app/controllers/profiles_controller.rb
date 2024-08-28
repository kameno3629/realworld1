class ProfilesController < ApplicationController
  def show
    @user = User.find_by_username(params[:username])
    render json: @user  # ユーザー情報をJSON形式で返す
  end
end
