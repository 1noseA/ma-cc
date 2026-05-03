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

    it "スコアが高いリードが先に表示される" do
      high_visitor = create(:visitor, score: 5)
      low_visitor  = create(:visitor, score: 1)
      create(:lead, visitor: high_visitor, email: "high@example.com")
      create(:lead, visitor: low_visitor,  email: "low@example.com")

      get admin_leads_path

      expect(response.body.index("high@example.com")).to be < response.body.index("low@example.com")
    end
  end

  describe "GET /admin/leads/:id" do
    it "リード詳細に行動履歴が表示される" do
      lead = create(:lead)
      create(:event, visitor: lead.visitor, path: "/articles/1", occurred_at: 1.hour.ago)

      get admin_lead_path(lead)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("/articles/1")
    end

    it "リード詳細にフォーム送信履歴が表示される" do
      lead = create(:lead)
      form = create(:form)
      create(:form_submission, visitor: lead.visitor, form: form, email: "sub@example.com")

      get admin_lead_path(lead)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("sub@example.com")
    end
  end
end
