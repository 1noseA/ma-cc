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

  end
end
