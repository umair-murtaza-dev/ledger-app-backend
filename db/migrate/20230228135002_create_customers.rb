class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.references :company, null: false, foreign_key: true, index: true
      t.string :firstname
      t.string :lastname
      t.string :phone
      t.string :address
      t.string :currency

      t.timestamps
    end
  end
end
