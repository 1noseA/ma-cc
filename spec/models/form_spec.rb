require "rails_helper"

RSpec.describe Form, type: :model do
  describe "validations" do
    it "name がない Form は無効" do
      form = Form.new(name: nil)
      expect(form).not_to be_valid
      expect(form.errors[:name]).to be_present
    end
  end
end
