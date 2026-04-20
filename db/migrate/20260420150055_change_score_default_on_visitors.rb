class ChangeScoreDefaultOnVisitors < ActiveRecord::Migration[8.1]
  def change
    change_column_default :visitors, :score, from: nil, to: 0
  end
end
