require "rails_helper"

RSpec.describe "MVPシナリオ", type: :system do
  before { driven_by(:rack_test) }

  let!(:form)         { create(:form) }
  let!(:display_rule) { create(:display_rule, form: form, rule_type: "visit_count_gte", threshold: 3, enabled: true) }
  let!(:articles)     { create_list(:article, 3) }
  let!(:admin)        { create(:user) }

  it "訪問→閲覧→フォーム表示→送信→管理画面でリード確認ができる" do
    # 1. ルートにアクセス（PV=1）
    visit root_path

    # 2. 記事を1件閲覧（PV=2、閾値未達）
    visit article_path(articles[0])
    expect(page).not_to have_css("form")

    # 3. もう1件閲覧（PV=3、閾値到達 → フォームが表示される）
    visit article_path(articles[1])
    expect(page).to have_css("form")

    # 4. フォームを送信
    fill_in "お名前", with: "テスト 太郎"
    fill_in "メールアドレス", with: "lead@example.com"
    click_button "送信する"
    expect(page).to have_content("送信ありがとうございました")

    # 5. 管理者ログイン
    visit new_session_path
    fill_in "メールアドレス", with: admin.email_address
    fill_in "パスワード", with: "password"
    click_button "ログイン"

    # 6. 訪問者一覧でリード化済みを確認
    visit admin_visitors_path
    expect(page).to have_content("リード化済み")

    # 7. リード一覧にスコア順で表示される
    visit admin_leads_path
    expect(page).to have_content("テスト 太郎")
    expect(page).to have_content("lead@example.com")

    # 8. リード詳細で閲覧履歴を確認
    click_link "テスト 太郎"
    expect(page).to have_content("/articles/")
  end
end
