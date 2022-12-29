class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.references :company, null: false, foreign_key: true, index: true
      t.string :firstname
      t.string :lastname

      t.timestamps
    end
  end
end
