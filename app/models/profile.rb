class Profile < ApplicationRecord
    belongs_to :user
  
    # バリデーションを追加
    validates :username, presence: true, uniqueness: true
    validates :bio, presence: true
    validates :image, presence: true
  
    # ユーザーがフォローしているかどうかを判定するメソッド
    def following?(other_user)
      user.following.include?(other_user)
    end
  end