require "rails_helper"

RSpec.describe Form, type: :model do
  describe "validations" do
    it "name がない Form は無効" do
      form = Form.new(name: nil)
      expect(form).not_to be_valid
      expect(form.errors[:name]).to be_present
    end
  end

  describe "#should_display_for?" do
    let(:form) { create(:form) }
    let(:visitor) { create(:visitor) }

    context "すべての表示ルールが条件を満たさない場合" do
      it "false を返す" do
        create(:display_rule, form: form, rule_type: "visit_count_gte", threshold: 3, enabled: true)
        create_list(:event, 2, visitor: visitor, event_type: "page_view")
        expect(form.should_display_for?(visitor)).to be false
      end
    end

    context "1つでも条件を満たす表示ルールがある場合" do
      it "true を返す" do
        create(:display_rule, form: form, rule_type: "visit_count_gte", threshold: 3, enabled: true)
        create_list(:event, 3, visitor: visitor, event_type: "page_view")
        expect(form.should_display_for?(visitor)).to be true
      end
    end
  end
end
