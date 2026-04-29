class FormSubmissionsController < PublicController
  def create
    @form = Form.find(params[:form_id])
    @form.form_submissions.create!(
      visitor: @current_visitor,
      email: params[:form_submission][:email],
      name: params[:form_submission][:name],
      submitted_at: Time.current
    )
  end
end
