class Post < ApplicationRecord
  include Likeable
  belongs_to :user
  belongs_to :post, optional: true
  has_many :comments
  has_many :moderators
  belongs_to :organization
  has_and_belongs_to_many :topics
  validates :body, length: { maximum: 800 }, allow_blank: false, unless: :post_id

  def post_type
    if post_id? && body?
      "quote-post"
    elsif post_id?
      "repost"
    else
      "post"
    end
  end
end
