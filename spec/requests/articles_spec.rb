require "rails_helper"

RSpec.describe "Articles", type: :request do
  describe "GET /articles" do
    it "200 が返る" do
      get "/articles"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /articles/:id" do
    it "公開されている記事の場合は 200 が返る" do
      article = create(:article, published: true)

      get "/articles/#{article.id}"

      expect(response).to have_http_status(:ok)
    end
  end
end
