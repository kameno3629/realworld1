class Article < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  scope :authored_by, ->(username) { where(user: User.where(username: username)) }
  scope :favorited_by, -> (username) { joins(:favorites).where(favorites: { user: User.where(username: username) }) }

  acts_as_taggable_on :tags

  validates :title, presence: true, allow_blank: false
  validates :body, presence: true, allow_blank: false
  validates :slug, uniqueness: true, exclusion: { in: ['feed'] }

  before_validation :generate_slug, if: :title_changed?

  private

  def generate_slug
    if title.present?
      base_slug = title.parameterize
      self.slug = base_slug
      count = 2
      while Article.exists?(slug: slug)
        self.slug = "#{base_slug}-#{count}"
        count += 1
      end
    end
  end
end
