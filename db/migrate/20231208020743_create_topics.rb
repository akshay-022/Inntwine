class CreateTopics < ActiveRecord::Migration[7.0]
  def change
    create_table :topics do |t|
      t.string :topic_path
      t.string :topic_name

      t.timestamps
    end

    add_column :posts, :topic_id, :integer
    add_column :posts, :organization_id, :integer
    add_foreign_key :posts, :organizations, column: :organization_id, on_delete: :cascade
    add_foreign_key :posts, :topics, column: :topic_id, on_delete: :cascade

  end
end
