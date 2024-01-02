class User < ApplicationRecord
  pay_customer

  has_person_name

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable  #, :confirmable
  has_many :posts
  has_many :user_organizations
  has_many :user_communities
  validates_uniqueness_of :username

  has_one_attached :profile_image

  def joined_community?(organization, topic)
    user_community = UserCommunity.find_by(user: self, organization: organization, topic: topic)
    return false unless user_community
    user_community.part_of
  end
  
end
