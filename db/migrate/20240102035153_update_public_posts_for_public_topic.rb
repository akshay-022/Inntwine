class UpdatePublicPostsForPublicTopic < ActiveRecord::Migration[7.0]
  def change
    # Find the topic with topic_id 0 or create it if it doesn't exist
    topic = Topic.find_by(id: 0)
    # Update posts with :is_private set to false to add the topic with topic_id 0 to their topics association
    Post.where(is_private: false).each do |post|
      post.topics << topic
      post.save
    end
  end
end
