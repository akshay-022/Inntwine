class ChangePostCategoryToStringArray < ActiveRecord::Migration[7.0]
  def change
    def up
      # Add a new column to temporarily hold the array values
      add_column :posts, :temp_post_category, :text, array: true, default: []
  
      # Update the new column with arrays containing the original string values
      execute "UPDATE posts SET temp_post_category = ARRAY[post_category]::text[]"
  
      # Remove the old column and rename the new one to match the original name
      #remove_column :posts, :post_category
      #rename_column :posts, :temp_post_category, :post_category
    end
  
    def down
      # Revert the changes by changing the column back to a string
      change_column :posts, :post_category, :string, array: false
    end
  end
end
