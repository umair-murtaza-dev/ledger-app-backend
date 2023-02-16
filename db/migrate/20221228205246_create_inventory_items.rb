class CreateInventoryItems < ActiveRecord::Migration[6.0]
  def change
    create_table :inventory_items do |t|
      t.references :company, null: false, foreign_key: true
      t.string :code, unique: true, index: true
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
