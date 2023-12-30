class PopulatePostsTopicsJoinTable < ActiveRecord::Migration[7.0]
  def change
    # Loop through each Post and associate it with the corresponding Topic based on :topic_id
    Post.find_each do |post|
      # Check if :topic_id is not nil
      if post.topic_id.present?
        # Find the Topic using :topic_id
        topic = Topic.find_by(id: post.topic_id)
        # Associate the Post with the Topic
        post.topics << topic if topic.present?
      end
    end
  end
end
