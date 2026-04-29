require "rails_helper"

RSpec.describe "Articles", type: :system do
  before { driven_by(:rack_test) }

  it "記事詳細ページに訪問するとフォームが表示される" do
    article = create(:article)

    visit article_path(article)

    expect(page).to have_css("form")
  end
end
