class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :article
# コメントの本文は必須で、空白を許可しない
  validates :body, presence: true, allow_blank: false

# created_at と updated_at は ActiveRecord によって自動的に管理される
end
