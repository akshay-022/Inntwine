class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations do |t|
      t.string :organization_path
      t.string :organization_name
      t.string :organization_email
      t.references :privacy, null: false, foreign_key: true
      t.timestamps
    end
  end
end
