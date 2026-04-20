require "rails_helper"

RSpec.describe "Visitor tracking", type: :request do
  describe "GET /articles" do
    it "初回アクセスで Visitor が1件作成される" do
      expect { get articles_path }.to change(Visitor, :count).by(1)
    end
  end

  describe "GET /" do
    it "初回アクセスで Visitor が1件作成される" do
      expect { get root_path }.to change(Visitor, :count).by(1)
    end

    it "同じ cookie で2回アクセスしても Visitor は増えない" do
      get root_path
      expect { get root_path }.not_to change(Visitor, :count)
    end

    it "cookie をクリアして再アクセスすると別の Visitor が作成される" do
      get root_path
      cookies[:visitor_token] = SecureRandom.uuid  # DB に存在しないトークンでリセットを模倣
      expect { get root_path }.to change(Visitor, :count).by(1)
    end
  end
end
