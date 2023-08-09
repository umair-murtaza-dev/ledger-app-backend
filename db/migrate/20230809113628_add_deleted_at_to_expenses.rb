class AddDeletedAtToExpenses < ActiveRecord::Migration[6.0]
  def change
    add_column :expenses, :deleted_at, :datetime
    add_index :expenses, :deleted_at
  end
end
