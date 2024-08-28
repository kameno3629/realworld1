class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :new]

  def index
    @articles = Article.all.includes(:user)

    @articles = @articles.tagged_with(params[:tag]) if params[:tag].present?
    @articles = @articles.authored_by(params[:author]) if params[:author].present?
    @articles = @articles.favorited_by(params[:favorited]) if params[:favorited].present?

    @articles_count = @articles.count

    @articles = @articles.order(created_at: :desc).offset(params[:offset] || 0).limit(params[:limit] || 20)
    render json: @articles
  end

  def feed
    @articles = Article.includes(:user).where(user: current_user.following_users)

    @articles_count = @articles.count

    @articles = @articles.order(created_at: :desc).offset(params[:offset] || 0).limit(params[:limit] || 20)
    render json: @articles
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user

    if @article.save
      render json: @article, status: :created
    else
      render json: { errors: @article.errors }, status: :unprocessable_entity
    end
  end

  def new
    @article = Article.new
    render 'edit'  # edit.html.erb を使用するように指定
  end

  def show
    @article = Article.find_by_slug!(params[:slug])
    render json: @article
  end

  def update
    @article = Article.find_by_slug!(params[:slug])

    if @article.user_id == current_user.id
      if @article.update(article_params)
        render json: @article
      else
        render json: { errors: @article.errors }, status: :unprocessable_entity
      end
    else
      render json: { errors: { article: ['not owned by user'] } }, status: :forbidden
    end
  end

  def destroy
    @article = Article.find_by_slug!(params[:slug])

    if @article.user_id == current_user.id
      @article.destroy
      head :no_content
    else
      render json: { errors: { article: ['not owned by user'] } }, status: :forbidden
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :body, :description, tag_list: [])
  end
end