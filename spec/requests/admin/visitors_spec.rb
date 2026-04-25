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
  end
end
