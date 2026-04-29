class AddNotNullConstraintsToFormSubmissionsAndLeads < ActiveRecord::Migration[8.1]
  def change
    change_column_null :form_submissions, :email, false
    change_column_null :form_submissions, :name, false
    change_column_null :form_submissions, :submitted_at, false

    change_column_null :leads, :email, false
    change_column_null :leads, :name, false
    change_column_null :leads, :first_converted_at, false
  end
end
