class Moderator < ApplicationRecord
  belongs_to :user
  belongs_to :organization, optional: true
  has_many :communities
end
