class FormSubmissionsController < PublicController
  def create
    @form = Form.find(params[:form_id])
    @form.form_submissions.create!(
      visitor: @current_visitor,
      email: params[:form_submission][:email],
      name: params[:form_submission][:name],
      submitted_at: Time.current
    )
    Lead.find_or_create_by!(visitor: @current_visitor) do |lead|
      lead.email = params[:form_submission][:email]
      lead.name  = params[:form_submission][:name]
      lead.first_converted_at = Time.current
    end
  end
end
