require "rails_helper"

RSpec.describe "Home", type: :system do
  before { driven_by(:rack_test) }

  it "トップページ(LP)に訪問するとフォームが表示される" do
    visit root_path

    expect(page).to have_css("form")
  end
end
