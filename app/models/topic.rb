class Topic < ApplicationRecord
    belongs_to :parent, class_name: 'Topic', optional: true
    has_many :children, class_name: 'Topic', foreign_key: 'parent_id'
    has_many :posts
end
