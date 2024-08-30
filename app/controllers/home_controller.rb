# app/controllers/home_controller.rb
class HomeController < ApplicationController
    def index
      @articles = Article.all.order(created_at: :desc)
    end
  end