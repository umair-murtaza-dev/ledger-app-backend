class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
      t.string :from_name
      t.string :from_address
      t.string :from_phone
      t.string :to_name
      t.string :to_address
      t.string :to_phone
      t.integer :status
      t.string :currency, null: false
      t.float :amount, default: 0, null: false
      t.float :tax_percentage, default: 0, null: false
      t.float :discount_percentage, default: 0, null: false
      t.float :total_amount, null: true
      t.references :user, null: true
      t.references :company, null: false, foreign_key: true
      t.timestamps
    end
  end
end
