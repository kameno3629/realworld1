class ArticlesController < ApplicationController
  # before_action :authenticate_user!, except: [:index, :show, :new, :create]
  # ユーザー認証を一時的に無効化

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
    # ユーザー認証を一時的に無効化
    # @article.user = current_user
    if @article.save
      redirect_to root_path  # 記事が保存された後、ホームページにリダイレクト
    else
      render json: { errors: @article.errors }, status: :unprocessable_entity
    end
  end

  def new
    @article = Article.new
    render 'edit'  # edit.html.erb を使用するように指定
  end

  def show
    @article = Article.find_by(slug: params[:slug])
    if @article.nil?
      redirect_to root_path, alert: "指定された記事が見つかりません。"  # 記事が見つからない場合にホームページにリダイレクト
    end
    # 記事が見つかった場合は、デフォルトの動作で show ビューがレンダリングされます。
  end

  def update
    @article = Article.find_by!(slug: params[:slug])
    if @article.user_id == @current_user_id
      @article.update_attributes(article_params)
      render :show
    else
      render json: { errors: { article: ['not owned by user'] } }, status: :forbidden
    end
  end

  def destroy
    @article = Article.find_by!(slug: params[:slug])
    if @article.user_id == @current_user_id
      @article.destroy
      render json: {}
    else
      render json: { errors: { article: ['not owned by user'] } }, status: :forbidden
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :body, :description, tag_list: [])
  end
end
