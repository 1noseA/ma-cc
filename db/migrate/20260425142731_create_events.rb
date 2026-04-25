class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.references :visitor, null: false, foreign_key: true
      t.string :event_type
      t.string :path
      t.datetime :occurred_at

      t.timestamps
    end

    add_index :events, [:visitor_id, :occurred_at]
    add_index :events, :event_type
  end
end
