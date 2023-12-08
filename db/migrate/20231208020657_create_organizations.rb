class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations do |t|
      t.string :organization_path
      t.string :organization_name
      t.string :organization_email
      t.references :privacy, null: false, foreign_key: true
      t.timestamps
    end

    # Add columns to users table
    add_column :users, :organization_id, :integer

    # Add foreign key to organizations table
    add_foreign_key :organizations, :privacies, column: :privacy_id, on_delete: :cascade
  end
end
