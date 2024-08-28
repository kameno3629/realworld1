class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :articles, dependent: :destroy
  has_many :favorites, class_name: 'Article', through: :favorite_articles
  has_many :favorite_articles, dependent: :destroy # お気に入りの記事
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :followed_users, class_name: 'User', through: :follower_relationships, source: :followed
  has_many :follower_relationships, foreign_key: :follower_id, class_name: 'Follow'
  has_many :following_users, class_name: 'User', through: :following_relationships, source: :following
  has_many :following_relationships, foreign_key: :following_id, class_name: 'Follow'

  acts_as_follower
  acts_as_followable

  validates :username, uniqueness: { case_sensitive: true },
                       format: { with: /\A[a-zA-Z0-9]+\z/ },
                       presence: true,
                       allow_blank: false
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create # パスワードは作成時のみ必須
  # bioとimageのバリデーションを追加
  validates :bio, presence: true, allow_blank: true
  validates :image, presence: true, allow_blank: true


  # JWTトークン生成
  def generate_jwt
    JWT.encode({ id: id,
                 exp: 60.days.from_now.to_i },
               Rails.application.secrets.secret_key_base)
  end

    # お気に入り関連のメソッド
  def favorite(article)
    favorites.find_or_create_by(article: article)
  end

  def unfavorite(article)
    favorites.where(article: article).destroy_all

    article.reload
  end

  def favorited?(article)
    favorites.find_by(article_id: article.id).present?
  end
end
