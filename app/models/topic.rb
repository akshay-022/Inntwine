class Topic < ApplicationRecord
    belongs_to :parent, class_name: 'Topic', optional: true
    has_many :children, class_name: 'Topic', foreign_key: 'parent_id'
    has_and_belongs_to_many :posts

    # Instance method to get the full pathname
    def full_path_name
        # Split the topic_path into individual topic IDs
        path_ids = self.topic_path.split('/')

        # Map the IDs to their corresponding topic names
        path_names = path_ids.map do |id|
        topic = Topic.find_by(id: id)
        topic ? topic.topic_name : nil
        end

        # Join the names with slashes and return the full path name
        path_names.compact.join('/')
    end
end
