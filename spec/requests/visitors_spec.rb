require "rails_helper"

RSpec.describe "Visitor tracking", type: :request do
  describe "GET /" do
    it "初回アクセスで Visitor が1件作成される" do
      expect { get root_path }.to change(Visitor, :count).by(1)
    end
  end
end
