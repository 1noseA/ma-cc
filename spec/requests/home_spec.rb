require "rails_helper"

RSpec.describe "Home", type: :request do
  describe "GET /" do
    it "200 が返る" do
      get "/"
      expect(response).to have_http_status(:ok)
    end

    context "表示ルールあり (threshold=3)" do
      let!(:form) { create(:form) }
      let!(:display_rule) { create(:display_rule, form: form, rule_type: "visit_count_gte", threshold: 3, enabled: true) }

      it "閾値未達の訪問者にはフォームが描画されない" do
        2.times { get "/" }

        expect(response.body).not_to include("お問い合わせ")
      end

      it "閾値を超えた訪問者にはフォームが描画される" do
        3.times { get "/" }

        expect(response.body).to include("お問い合わせ")
      end
    end
  end
end
