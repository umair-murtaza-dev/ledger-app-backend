class AddExpenseToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_reference :accounts, :expense, foreign_key: true
  end
end
