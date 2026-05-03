require "rails_helper"

RSpec.describe "FormSubmissions", type: :request do
  describe "POST /forms/:form_id/submissions" do
    let(:form) { create(:form) }

    before { get root_path }  # visitor cookie を発行

    it "フォームを送信すると FormSubmission が作られる" do
      expect {
        post form_submissions_path(form),
             params: { form_submission: { email: "test@example.com", name: "テスト 太郎" } }
      }.to change(FormSubmission, :count).by(1)
    end

    it "フォームを送信すると Lead が作られる" do
      expect {
        post form_submissions_path(form),
             params: { form_submission: { email: "test@example.com", name: "テスト 太郎" } }
      }.to change(Lead, :count).by(1)
    end

    it "フォームを送信すると form_submit イベントが記録される" do
      expect {
        post form_submissions_path(form),
             params: { form_submission: { email: "test@example.com", name: "テスト 太郎" } }
      }.to change(Event.form_submits, :count).by(1)
    end

    it "フォームを送信するとサンクスページにリダイレクトされる" do
      post form_submissions_path(form),
           params: { form_submission: { email: "test@example.com", name: "テスト 太郎" } }
      expect(response).to redirect_to(thanks_form_path(form))
    end

    it "同じ訪問者が2回送信しても Lead は1件のみ" do
      post form_submissions_path(form),
           params: { form_submission: { email: "first@example.com", name: "一回目" } }
      expect {
        post form_submissions_path(form),
             params: { form_submission: { email: "second@example.com", name: "二回目" } }
      }.not_to change(Lead, :count)
    end

    it "フォームを送信すると visitor のスコアが再計算される" do
      post form_submissions_path(form),
           params: { form_submission: { email: "test@example.com", name: "テスト 太郎" } }
      visitor = Visitor.find_by(visitor_token: cookies.signed[:visitor_token])
      expect(visitor.reload.score).to eq(4)
    end
  end
end
