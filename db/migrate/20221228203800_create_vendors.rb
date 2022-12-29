class CreateVendors < ActiveRecord::Migration[6.0]
  def change
    create_table :vendors do |t|
      t.references :company, null: false, foreign_key: true
      t.string :code, null: false, index: true
      t.string :title, null: false, index: true
      t.string :address

      t.timestamps
    end
  end
end
