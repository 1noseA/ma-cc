require "rails_helper"

RSpec.describe "Forms", type: :request do
  describe "GET /forms/:id/thanks" do
    it "200 を返す" do
      form = create(:form)

      get thanks_form_path(form)

      expect(response).to have_http_status(:ok)
    end
  end
end
