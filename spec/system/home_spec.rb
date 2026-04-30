require "rails_helper"

RSpec.describe "Home", type: :system do
  before { driven_by(:rack_test) }

  context "表示ルールあり (threshold=3)" do
    let!(:form) { create(:form) }
    let!(:display_rule) { create(:display_rule, form: form, rule_type: "visit_count_gte", threshold: 3, enabled: true) }

    it "閾値未達の訪問者にはフォームが表示されない" do
      2.times { visit root_path }

      expect(page).not_to have_css("form")
    end

    it "閾値を超えた訪問者にはフォームが表示される" do
      3.times { visit root_path }

      expect(page).to have_css("form")
    end
  end
end
