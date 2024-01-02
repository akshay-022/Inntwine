class AddUnreadColumnsToConversations < ActiveRecord::Migration[7.0]
  def change
    add_column :conversations, :sender_unread, :boolean
    add_column :conversations, :recipient_unread, :boolean
  end
end
