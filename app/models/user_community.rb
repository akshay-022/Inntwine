class UserCommunity < ApplicationRecord
  belongs_to :user
  belongs_to :organization
  belongs_to :topic
end
