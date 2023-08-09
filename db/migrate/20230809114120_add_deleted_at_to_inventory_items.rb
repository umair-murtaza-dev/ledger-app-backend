class AddDeletedAtToInventoryItems < ActiveRecord::Migration[6.0]
  def change
    add_column :inventory_items, :deleted_at, :datetime
    add_index :inventory_items, :deleted_at
  end
end
