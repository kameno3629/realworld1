# app/controllers/home_controller.rb
class HomeController < ApplicationController
    def index
        @articles = Article.includes(:user).order(created_at: :desc).limit(10)
        @tags = ActsAsTaggableOn::Tag.most_used(10)
    end
end