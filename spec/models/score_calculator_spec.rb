require "rails_helper"

RSpec.describe ScoreCalculator do
  describe "#call" do
    let(:visitor) { create(:visitor) }

    it "page_view は1点" do
      create(:event, visitor: visitor, event_type: "page_view")
      expect(ScoreCalculator.new(visitor).call).to eq(1)
    end

    it "form_submit は3点" do
      create(:event, visitor: visitor, event_type: "form_submit")
      expect(ScoreCalculator.new(visitor).call).to eq(3)
    end

    it "複数イベントのスコアを合算する" do
      create(:event, visitor: visitor, event_type: "page_view")
      create(:event, visitor: visitor, event_type: "page_view")
      create(:event, visitor: visitor, event_type: "form_submit")
      expect(ScoreCalculator.new(visitor).call).to eq(5)
    end

    it "イベントがない場合は0" do
      expect(ScoreCalculator.new(visitor).call).to eq(0)
    end
  end
end
