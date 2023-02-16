class CreateStoreLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :store_locations do |t|
      t.references :company, null: false, foreign_key: true
      t.string :code, unique: true, index: true
      t.integer :manager_id

      t.timestamps
    end
  end
end
