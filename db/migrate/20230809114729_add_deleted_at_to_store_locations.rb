class AddDeletedAtToStoreLocations < ActiveRecord::Migration[6.0]
  def change
    add_column :store_locations, :deleted_at, :datetime
    add_index :store_locations, :deleted_at
  end
end
