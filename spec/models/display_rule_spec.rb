require "rails_helper"

RSpec.describe DisplayRule, type: :model do
  describe "バリデーション" do
    let(:form) { create(:form) }

    it "rule_type が nil の場合は invalid" do
      rule = build(:display_rule, form: form, rule_type: nil)
      expect(rule).not_to be_valid
    end

    context "visit_count_gte ルール" do
      it "threshold が nil の場合は invalid" do
        rule = build(:display_rule, form: form, rule_type: "visit_count_gte", threshold: nil)
        expect(rule).not_to be_valid
      end

      it "threshold が負の場合は invalid" do
        rule = build(:display_rule, form: form, rule_type: "visit_count_gte", threshold: -1)
        expect(rule).not_to be_valid
      end

      it "threshold が 0 以上の整数なら valid" do
        rule = build(:display_rule, form: form, rule_type: "visit_count_gte", threshold: 0)
        expect(rule).to be_valid
      end
    end
  end

  describe "#matches?" do
    let(:form) { create(:form) }
    let(:display_rule) { build(:display_rule, form: form, rule_type: "visit_count_gte", threshold: 3, enabled: true) }

    context "enabled=false のとき" do
      it "page_view が threshold 以上でも false を返す" do
        disabled_rule = build(:display_rule, form: form, rule_type: "visit_count_gte", threshold: 3, enabled: false)
        visitor = create(:visitor)
        create_list(:event, 3, visitor: visitor, event_type: "page_view")
        expect(disabled_rule.matches?(visitor)).to be false
      end
    end

    context "visit_count_gte ルール" do
      it "page_view が threshold 未満の訪問者に対して false を返す" do
        visitor = create(:visitor)
        create_list(:event, 2, visitor: visitor, event_type: "page_view")
        expect(display_rule.matches?(visitor)).to be false
      end

      it "page_view が threshold 以上の訪問者に対して true を返す" do
        visitor = create(:visitor)
        create_list(:event, 3, visitor: visitor, event_type: "page_view")
        expect(display_rule.matches?(visitor)).to be true
      end
    end
  end
end
