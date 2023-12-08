class Moderator < ApplicationRecord
  belongs_to :user
  has_many :communities
end
