class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string :title, null: false
      t.boolean :is_company_admin, null: false, default: false
      t.boolean :is_admin, null: false, default: false
      t.boolean :deleted_at

      t.timestamps
    end
  end
end
