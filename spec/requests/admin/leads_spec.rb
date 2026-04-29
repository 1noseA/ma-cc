require "rails_helper"

RSpec.describe "Admin::Leads", type: :request do
  let(:user) { create(:user) }

  before do
    get "/admin"
    post session_url, params: {
      email_address: user.email_address,
      password: "password"
    }
  end

  describe "GET /admin/leads" do
    it "管理画面のリード一覧にリードが表示される" do
      lead = create(:lead)

      get admin_leads_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(lead.email)
    end
  end
end
