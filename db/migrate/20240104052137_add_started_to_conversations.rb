class AddStartedToConversations < ActiveRecord::Migration[7.0]
  def change
    add_column :conversations, :started, :boolean, default: false # Set the default value as needed
  end
end
