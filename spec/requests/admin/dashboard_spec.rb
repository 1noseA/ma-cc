require "rails_helper"

RSpec.describe "Admin::Dashboard", type: :request do
  describe "GET /admin" do
    context "未認証の場合" do
      it "ログイン画面にリダイレクトされる" do
        get "/admin"

        expect(response).to redirect_to(new_session_path)
      end
    end

    context "認証済みの場合" do
      let(:user) { create(:user) }

      before do
        # /admin にアクセスしてから return_to URL を保存させ、
        # その後ログイン → 保存された /admin にリダイレクトされる流れを踏む。
        # (T04 で root ルートを追加するまでは root_url へのフォールバックが失敗するため)
        get "/admin"
        post session_url, params: {
          email_address: user.email_address,
          password:      "password"
        }
      end

      it "200 が返る" do
        get "/admin"

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
