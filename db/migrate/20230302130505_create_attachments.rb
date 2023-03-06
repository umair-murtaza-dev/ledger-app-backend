class CreateAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :attachments do |t|
      t.references :company, null: false, foreign_key: true
      t.references :attachment_for, polymorphic: true, index: {name: 'attachment_for'}
    end
  end
end
