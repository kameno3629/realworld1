require 'rails_helper'

RSpec.describe "Articles", type: :request do
  describe "POST /api/articles" do
    it "creates a new article" do
      # 記事のパラメータを設定
      article_params = {
        article: {
          title: "Test Article",
          description: "This is a test article",
          body: "This is the body of the test article",
          tagList: ["test", "article"]
        }
      }

      # POSTリクエストを送信
      post "/api/articles", params: article_params

      # レスポンスが201 (Created) であることを確認
      expect(response).to have_http_status(:created)

      # レスポンスのJSONが正しいことを確認
      json_response = JSON.parse(response.body)
      expect(json_response['article']['title']).to eq("Test Article")
      expect(json_response['article']['description']).to eq("This is a test article")
      expect(json_response['article']['body']).to eq("This is the body of the test article")
    end
  end
end