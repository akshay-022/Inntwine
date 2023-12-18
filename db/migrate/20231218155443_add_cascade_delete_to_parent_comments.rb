class AddCascadeDeleteToParentComments < ActiveRecord::Migration[7.0]
  def change
    # Remove existing foreign key constraint on parent_comment_id, if it exists.
    remove_foreign_key :comments, :comments, column: :parent_comment_id, if_exists: true

    # Add foreign key constraint with cascade delete on parent_comment_id.
    # This references the id column in the same comments table.
    add_foreign_key :comments, :comments, column: :parent_comment_id, primary_key: :id, on_delete: :cascade
  end
  
end
