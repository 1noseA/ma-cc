class CreateForms < ActiveRecord::Migration[8.1]
  def change
    create_table :forms do |t|
      t.string :name
      t.string :description
      t.string :success_message

      t.timestamps
    end
  end
end
