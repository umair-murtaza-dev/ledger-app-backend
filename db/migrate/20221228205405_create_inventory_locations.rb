class CreateInventoryLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :inventory_locations do |t|
      t.references :company, null: false, foreign_key: true
      t.references :inventory_item, null: false, foreign_key: true
      t.references :store_location, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
