class AddCustomFieldsAndCreateTables < ActiveRecord::Migration[7.0]
  def change
    # db/migrate/20231212000000_add_custom_fields_and_create_tables.rb

    # Create privacies table
    create_table :privacies do |t|
      t.string :name
      # Add any other fields for privacies as needed
      t.timestamps
    end

    # Create organizations table
    create_table :organizations do |t|
      t.string :name
      t.text :organization_path
      t.text :email_suffix
      t.integer :privacy_id
      # Add any other fields for organizations as needed
      t.timestamps
    end

    # Create topics table
    create_table :topics do |t|
      t.string :name
      t.text :topic_path
      # Add any other fields for organizations as needed
      t.timestamps
    end

    # Add foreign key to organizations table
    add_foreign_key :organizations, :privacies, column: :privacy_id, on_delete: :cascade

    # Create datathings table
    create_table :datathings do |t|
      t.text :content
      t.string :link_to_photo_video
      # Add any other fields for datathings as needed
      t.timestamps
    end

    # Create poll_types table
    create_table :poll_types do |t|
      t.string :name
      # Add any other fields for poll_types as needed
      t.timestamps
    end

    # Create post_types table
    create_table :post_types do |t|
      t.string :name
      # Add any other fields for post_types as needed
      t.timestamps
    end

    # Add columns to posts table
    add_column :posts, :parent_post_id, :integer
    add_column :posts, :datathing_id, :integer
    add_column :posts, :post_type_id, :integer
    add_column :posts, :organization_id, :integer
    add_column :posts, :topic_id, :integer
    add_column :posts, :q1, :text
    add_column :posts, :q1_type, :integer
    add_column :posts, :q1_args, :string
    add_column :posts, :q1_percentages, :string
    add_column :posts, :q2, :text
    add_column :posts, :q2_type, :integer
    add_column :posts, :q2_args, :string
    add_column :posts, :q2_percentages, :string
    add_column :posts, :likes, :integer

    add_foreign_key :posts, :posts, column: :parent_post_id, on_delete: :cascade
    add_foreign_key :posts, :datathings, column: :datathing_id, on_delete: :cascade
    add_foreign_key :posts, :post_types, column: :post_type_id, on_delete: :cascade
    add_foreign_key :posts, :organizations, column: :organization_id, on_delete: :cascade
    add_foreign_key :posts, :topics, column: :topic_id, on_delete: :cascade
    add_foreign_key :posts, :poll_types, column: :q1_type, on_delete: :cascade
    add_foreign_key :posts, :poll_types, column: :q2_type, on_delete: :cascade

    # Add columns to users table
    add_column :users, :organization_id, :integer
  end
end
