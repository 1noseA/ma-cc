require "rails_helper"

RSpec.describe DisplayRule, type: :model do
  describe "#matches?" do
    let(:form) { create(:form) }
    let(:display_rule) { build(:display_rule, form: form, rule_type: "visit_count_gte", threshold: 3, enabled: true) }

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
