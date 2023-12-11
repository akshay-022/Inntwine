class AddModerationStatusToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :moderation_status, :string, default: "pending"
  end
end
