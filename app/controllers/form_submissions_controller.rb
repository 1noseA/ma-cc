class FormSubmissionsController < PublicController
  def create
    @form = Form.find(params[:form_id])
    @form.form_submissions.create!(
      visitor: @current_visitor,
      email: submission_params[:email],
      name: submission_params[:name],
      submitted_at: Time.current
    )
    # ブロックは新規作成時のみ実行される。既存リードの email/name は更新しない（初回コンバージョン優先）
    Lead.find_or_create_by!(visitor: @current_visitor) do |lead|
      lead.email = submission_params[:email]
      lead.name  = submission_params[:name]
      lead.first_converted_at = Time.current
    end
    @current_visitor.events.create!(
      event_type: "form_submit",
      path: request.path,
      occurred_at: Time.current
    )
    @current_visitor.recalculate_score!
    redirect_to thanks_form_path(@form)
  end

  private

  def submission_params
    params.require(:form_submission).permit(:email, :name)
  end
end
