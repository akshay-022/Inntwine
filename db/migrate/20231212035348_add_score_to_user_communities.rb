class AddScoreToUserCommunities < ActiveRecord::Migration[7.0]
  def change
    add_column :user_communities, :score, :integer, default: 0
  end
end
