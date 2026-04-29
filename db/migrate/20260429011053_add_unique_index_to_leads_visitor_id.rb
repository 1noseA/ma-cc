class AddUniqueIndexToLeadsVisitorId < ActiveRecord::Migration[8.1]
  def change
    remove_index :leads, :visitor_id
    add_index :leads, :visitor_id, unique: true
  end
end
