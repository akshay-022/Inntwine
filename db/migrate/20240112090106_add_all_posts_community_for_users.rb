class AddAllPostsCommunityForUsers < ActiveRecord::Migration[7.0]
  def up
    users_to_add = User.where.not(id: UserCommunity.where(organization_id: 2, topic_id: 0).pluck(:user_id))
    # Create UserCommunity records for the selected users
    users_to_add.each do |user|
      UserCommunity.create(user: user, organization_id: 2, topic_id: 0, part_of: true)
    end
  end

  def down
    # Remove the UserCommunity records created in the 'up' method if necessary
    UserCommunity.where(score: 0).destroy_all
  end
end
