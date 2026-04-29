require "rails_helper"

RSpec.describe FormSubmission, type: :model do
  it "email または name がない FormSubmission は無効" do
    expect(build(:form_submission, email: nil)).not_to be_valid
    expect(build(:form_submission, name: nil)).not_to be_valid
  end
end
