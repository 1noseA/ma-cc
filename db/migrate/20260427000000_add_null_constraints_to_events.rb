class AddNullConstraintsToEvents < ActiveRecord::Migration[8.1]
  def change
    change_column_null :events, :event_type, false
    change_column_null :events, :path, false
    change_column_null :events, :occurred_at, false
  end
end
