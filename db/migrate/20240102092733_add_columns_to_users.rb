class AddColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :position, :string
    add_column :users, :bio, :text
    add_column :users, :profile_picture, :binary
  end
end
