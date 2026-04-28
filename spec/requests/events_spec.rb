require "rails_helper"

RSpec.describe "Event tracking", type: :request do
  describe "GET /articles/:id" do
    let!(:article) { create(:article) }

    it "公開ページを閲覧すると page_view イベントが記録される" do
      expect { get article_path(article) }.to change(Event, :count).by(1)
      event = Event.last
      expect(event.event_type).to eq("page_view")
    end
  end
end
