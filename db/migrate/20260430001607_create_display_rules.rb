class CreateDisplayRules < ActiveRecord::Migration[8.1]
  def change
    create_table :display_rules do |t|
      t.references :form, null: false, foreign_key: true
      t.string :rule_type
      t.integer :threshold
      t.boolean :enabled, null: false, default: true

      t.timestamps
    end
  end
end
