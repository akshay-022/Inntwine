class AddCascadeDeleteToVotes < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :votes, :posts
    remove_foreign_key :votes, :users

    add_foreign_key :votes, :posts, on_delete: :cascade
    add_foreign_key :votes, :users, on_delete: :cascade
  end
end
