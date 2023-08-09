class AddDeletedAtToInventoryLocations < ActiveRecord::Migration[6.0]
  def change
    add_column :inventory_locations, :deleted_at, :datetime
    add_index :inventory_locations, :deleted_at
  end
end
