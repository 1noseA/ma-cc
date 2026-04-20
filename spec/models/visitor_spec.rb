require "rails_helper"

RSpec.describe Visitor, type: :model do
  describe "デフォルト値" do
    it "score のデフォルトは 0" do
      visitor = Visitor.new
      expect(visitor.score).to eq(0)
    end
  end

  describe "バリデーション" do
    it "visitor_token が無い場合は無効" do
      visitor = Visitor.new(visitor_token: nil)
      expect(visitor).not_to be_valid
      expect(visitor.errors[:visitor_token]).to be_present
    end

    it "visitor_token が重複している場合は無効" do
      create(:visitor, visitor_token: "dup_token")
      visitor = Visitor.new(visitor_token: "dup_token")
      expect(visitor).not_to be_valid
      expect(visitor.errors[:visitor_token]).to be_present
    end

    it "first_visited_at が無い場合は無効" do
      visitor = build(:visitor, first_visited_at: nil)
      expect(visitor).not_to be_valid
      expect(visitor.errors[:first_visited_at]).to be_present
    end

    it "last_visited_at が無い場合は無効" do
      visitor = build(:visitor, last_visited_at: nil)
      expect(visitor).not_to be_valid
      expect(visitor.errors[:last_visited_at]).to be_present
    end
  end
end
