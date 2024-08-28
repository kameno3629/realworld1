module Profiles
    class FollowsController < ApplicationController
      before_action :authenticate_user!
  
      # ユーザーをフォローするアクション
      def create
        @profile = User.find_by_username(params[:username])
        current_user.follow(@profile)
        render json: @profile  # フォロー後のプロファイル情報を返す
      end
  
      # ユーザーのフォローを解除するアクション
      def destroy
        @profile = User.find_by_username(params[:username])
        current_user.unfollow(@profile)
        render json: @profile  # アンフォロー後のプロファイル情報を返す
      end
    end
  end