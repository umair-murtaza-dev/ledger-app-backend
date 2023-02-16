class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.references :company, null: false, foreign_key: true, index: true
      t.string :title
      t.timestamp :start_date
      t.timestamp :end_date

      t.timestamps
    end
  end
end
