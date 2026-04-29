require "rails_helper"

RSpec.describe Lead, type: :model do
  it "email または name がない Lead は無効" do
    expect(build(:lead, email: nil)).not_to be_valid
    expect(build(:lead, name: nil)).not_to be_valid
  end
end
