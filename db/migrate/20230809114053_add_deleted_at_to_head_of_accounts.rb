class AddDeletedAtToHeadOfAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :head_of_accounts, :deleted_at, :datetime
    add_index :head_of_accounts, :deleted_at
  end
end
