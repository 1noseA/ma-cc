require "rails_helper"

RSpec.describe "Home", type: :request do
  describe "GET /" do
    it "200 が返る" do
      get "/"
      expect(response).to have_http_status(:ok)
    end
  end
end
