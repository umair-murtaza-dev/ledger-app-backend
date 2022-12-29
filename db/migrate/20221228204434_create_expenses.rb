class CreateExpenses < ActiveRecord::Migration[6.0]
  def change
    create_table :expenses do |t|
      t.references :company, null: false, foreign_key: true, index: true
      t.references :vendor, null: false, foreign_key: true, index: true
      t.references :head_of_account, null: false, foreign_key: true, index: true
      t.references :user, null: false, foreign_key: true, index: true
      t.float :amount, default: 0.0, precision: 2
      t.text :description
      t.string :title
      t.float :sales_tax, default: 0.0, precision: 2
      t.float :witholding_tax, default: 0.0, precision: 2

      t.timestamps
    end
  end
end
