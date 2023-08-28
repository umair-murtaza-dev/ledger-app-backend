class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :title, null: false
      t.string :bank_name
      t.string :account_no
      t.string :iban
      t.string :currency
      t.integer :account_type
      t.float :balance

      t.references :user, null: false, foreign_key: true
      t.references :head_of_account, null: true, foreign_key: true
      t.references :company, null: false, foreign_key: true

      t.boolean :deleted_at
      t.timestamps
    end
  end
end
