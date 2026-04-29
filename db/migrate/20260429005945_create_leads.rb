class CreateLeads < ActiveRecord::Migration[8.1]
  def change
    create_table :leads do |t|
      t.references :visitor, null: false, foreign_key: true
      t.string :email
      t.string :name
      t.datetime :first_converted_at

      t.timestamps
    end
  end
end
