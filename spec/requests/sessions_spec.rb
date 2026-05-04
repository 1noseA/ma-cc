require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }

  describe "POST /session" do
    it "ログイン後に管理ダッシュボードへリダイレクトされる" do
      post session_url, params: {
        email_address: user.email_address,
        password: "password"
      }
      expect(response).to redirect_to(admin_root_path)
    end

    it "認証が必要なページ経由でログインすると元のページへリダイレクトされる" do
      get admin_visitors_path  # return_to_after_authenticating をセット
      post session_url, params: {
        email_address: user.email_address,
        password: "password"
      }
      expect(response).to redirect_to(admin_visitors_path)
    end

    it "パスワードが誤っている場合はログイン画面に戻る" do
      post session_url, params: {
        email_address: user.email_address,
        password: "wrong"
      }
      expect(response).to redirect_to(new_session_path)
    end
  end
end
