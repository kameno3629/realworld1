class ArticlesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update]
  before_action :set_article, only: [:destroy, :update]

  def index
    @articles = Article.all.includes(:user)

    @articles = @articles.tagged_with(params[:tag]) if params[:tag].present?
    @articles = @articles.authored_by(params[:author]) if params[:author].present?
    @articles = @articles.favorited_by(params[:favorited]) if params[:favorited].present?

    @articles_count = @articles.count

    @articles = @articles.order(created_at: :desc).offset(params[:offset] || 0).limit(params[:limit] || 20)
  end

  def feed
    @articles = Article.includes(:user).where(user: current_user.following_users)

    @articles_count = @articles.count

    @articles = @articles.order(created_at: :desc).offset(params[:offset] || 0).limit(params[:limit] || 20)

    render :index
  end

  def create
    @article = Article.new(article_params)
    # @article.user = current_user  # 認証が不要ならこの行は不要

    if @article.save
      render 'show', status: :created  # ステータスを :created に設定
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
    
    respond_to do |format|
      format.json { render json: @article }
      format.html { render :show } # HTMLテンプレートがある場合
    end
  end

  def update
    @article = Article.find_by_slug!(params[:slug])

    # if @article.user_id == @current_user_id
    if @article.update(article_params)

      render :show
    else
      render json: { errors: @article.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @article.destroy
      render json: {}, status: :ok
    else
      render json: { errors: @article.errors }, status: :unprocessable_entity
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :body, :description, tag_list: [])
  end

  def set_article
    @article = Article.find_by_slug!(params[:slug])
  end
end
