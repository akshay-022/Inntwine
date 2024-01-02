class AddPartOfToUserCommunities < ActiveRecord::Migration[7.0]
  def change
    add_column :user_communities, :part_of, :boolean
  end
end
