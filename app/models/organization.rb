class Organization < ApplicationRecord
    has_many :users
    has_many :communities
    has_many :user_organizations 
    has_many :moderators
    belongs_to :privacy
end
