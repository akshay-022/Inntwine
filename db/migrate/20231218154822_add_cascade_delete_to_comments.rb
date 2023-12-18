class AddCascadeDeleteToComments < ActiveRecord::Migration[7.0]
  def up
    # Remove the old foreign_key
    remove_foreign_key :comments, :posts

    # Add the new foreign_key with cascade delete
    add_foreign_key :comments, :posts, on_delete: :cascade
  end

  def down
    # Remove the cascade delete foreign_key
    remove_foreign_key :comments, :posts

    # Add the original foreign_key
    add_foreign_key :comments, :posts
  end
end
