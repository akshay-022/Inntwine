class ModeratorRequest < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  belongs_to :organization
end
