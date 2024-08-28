class TagsController < ApplicationController
  # タグの一覧を取得するアクション
  def index
    # Articleモデルのtag_countsメソッドを使用して、最も使用されているタグを取得し、その名前をマッピング
    render json: { tags: Article.tag_counts.most_used.map(&:name) }
  end
end
