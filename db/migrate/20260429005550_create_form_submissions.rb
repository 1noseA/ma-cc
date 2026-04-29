class CreateFormSubmissions < ActiveRecord::Migration[8.1]
  def change
    create_table :form_submissions do |t|
      t.references :form, null: false, foreign_key: true
      t.references :visitor, null: false, foreign_key: true
      t.string :email
      t.string :name
      t.datetime :submitted_at

      t.timestamps
    end
  end
end
