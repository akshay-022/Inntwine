class Community < ApplicationRecord
  belongs_to :organization
  belongs_to :topic
  belongs_to :privacy
  has_many :moderators
end
