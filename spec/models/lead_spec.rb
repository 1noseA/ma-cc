require "rails_helper"

RSpec.describe Lead, type: :model do
  it "email または name がない Lead は無効" do
    expect(build(:lead, email: nil)).not_to be_valid
    expect(build(:lead, name: nil)).not_to be_valid
  end

  it "同じ訪問者が2件目の Lead を作ろうとすると無効" do
    visitor = create(:visitor)
    create(:lead, visitor: visitor)
    expect(build(:lead, visitor: visitor)).not_to be_valid
  end
end
