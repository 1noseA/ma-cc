require "rails_helper"

RSpec.describe Event, type: :model do
  describe "バリデーション" do
    it "event_type がない場合は無効" do
      event = build(:event, event_type: nil)
      expect(event).not_to be_valid
      expect(event.errors[:event_type]).to be_present
    end
  end
end
