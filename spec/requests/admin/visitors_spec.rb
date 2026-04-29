require "rails_helper"

RSpec.describe "Admin::Visitors", type: :request do
  let(:user) { create(:user) }

  before do
    get "/admin"
    post session_url, params: {
      email_address: user.email_address,
      password: "password"
    }
  end

  describe "GET /admin/visitors" do
    it "訪問者一覧が表示される" do
      visitor = create(:visitor)

      get admin_visitors_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(visitor.visitor_token)
    end

    it "リード化済みの訪問者に「リード化済み」と表示される" do
      visitor = create(:visitor)
      create(:lead, visitor: visitor)

      get admin_visitors_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("リード化済み")
    end
  end

  describe "GET /admin/visitors/:id" do
    it "訪問者詳細画面で行動履歴が時系列で表示される" do
      visitor = create(:visitor)
      older_event = create(:event, visitor: visitor, path: "/articles/1", occurred_at: 2.hours.ago)
      newer_event = create(:event, visitor: visitor, path: "/articles/2", occurred_at: 1.hour.ago)

      get admin_visitor_path(visitor)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("/articles/1")
      expect(response.body).to include("/articles/2")
      # 新しいイベントが先に表示される（時系列降順）
      expect(response.body.index("/articles/2")).to be < response.body.index("/articles/1")
    end
  end
end
