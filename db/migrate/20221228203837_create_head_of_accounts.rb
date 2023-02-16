class CreateHeadOfAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :head_of_accounts do |t|
      t.references :company, null: false, foreign_key: true
      t.string :code, null: false, unique: true, index: true
      t.string :title

      t.timestamps
    end
  end
end
