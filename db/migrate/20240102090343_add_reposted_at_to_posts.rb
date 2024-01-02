class AddRepostedAtToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :reposted_at, :datetime

    # Set the default value of reposted_at to created_at for existing records
    Post.all.each do |post|
      post.update(reposted_at: post.created_at)
    end
  end
end
