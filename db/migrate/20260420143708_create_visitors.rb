class CreateVisitors < ActiveRecord::Migration[8.1]
  def change
    create_table :visitors do |t|
      t.string :visitor_token
      t.datetime :first_visited_at
      t.datetime :last_visited_at
      t.integer :score

      t.timestamps
    end

    add_index :visitors, :visitor_token, unique: true
    add_index :visitors, :score
  end
end
