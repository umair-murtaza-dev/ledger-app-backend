class RemoveColumnsFromInvoices < ActiveRecord::Migration[6.0]
  def change
    remove_column :invoices, :from_name, :string
    remove_column :invoices, :from_address, :string
    remove_column :invoices, :from_phone, :string
    remove_column :invoices, :to_name, :string
    remove_column :invoices, :to_address, :string
    remove_column :invoices, :to_phone, :string
    remove_column :invoices, :currency, :string

    add_reference :invoices, :customer, foreign_key: true
  end
end
