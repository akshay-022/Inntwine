# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'csv'

#ADD ORGANIZATIONS
# Create Privacy records
privacy_public = Privacy.create(name: 'Public')
privacy_private = Privacy.create(name: 'Private')
privacy_restricted = Privacy.create(name: 'Restricted')

# Create Organizations
Organization.create(
  organization_path: '1',
  organization_name: 'Global',
  organization_email: '',
  privacy: privacy_public
)

Organization.create(
  organization_path: '2',
  organization_name: 'Columbia University',
  organization_email: 'columbia.edu',
  privacy: privacy_public
)


user1 = User.create!(
  email: "agi2108@columbia.edu",
  password: "Aksh@2211",
  first_name: "Akshay",
  last_name: "Iyer",
  admin: true,
  username: "akshay_022",
  is_moderator: false
)


user2 = User.create!(
  email: "akshaygiyer@columbia.edu",
  password: "Aksh@2211",
  first_name: "Akshay",
  last_name: "Iyer",
  admin: false,
  username: "akshay_023",
  is_moderator: false
)

user3 = User.create!(
  email: "op2281@columbia.edu",
  password: "password123",
  first_name: "Omkar",
  last_name: "Pitale",
  admin: false,
  username: "omkar2001",
  is_moderator: false
)


# Assuming Organization IDs 1 and 2 exist
organization_ids = [1, 2]

# Create UserOrganization entries for user1
organization_ids.each do |org_id|
  UserOrganization.create!(user: user1, organization_id: org_id)
end

# Create UserOrganization entries for user2
organization_ids.each do |org_id|
  UserOrganization.create!(user: user2, organization_id: org_id)
end

# Create UserOrganization entries for user2
organization_ids.each do |org_id|
  UserOrganization.create!(user: user3, organization_id: org_id)
end

# Define the path to your CSV file
csv_path = File.join(Rails.root, 'db', 'seed', 'Topics.csv')

Topic.create!(
    id: 0,
    topic_path: '0',
    topic_name: 'Commons',
    parent_id: nil
  )

# Read CSV and populate topics table
CSV.foreach(csv_path, headers: true) do |row|
  parent_id = row['parent_id'] == 'nil' ? nil : row['parent_id'].to_i
  Topic.create!(
    id: row['id'].to_i,
    topic_path: row['topic_path'],
    topic_name: row['topic_name'],
    parent_id: parent_id
  )
end

# Assuming you have User records with IDs 1 and 2
user1 = User.find(1)
user2 = User.find(2)
user3 = User.find(3)

# Create the connection from user2 to user1
Connection.create(follower: user2, followed: user1, mutual: true)
Connection.create(follower: user3, followed: user1, mutual: false)

#Creating user_communities
UserCommunity.create(user_id: 1, organization_id: 2, topic_id: 1, score: 5)
UserCommunity.create(user_id: 2, organization_id: 2, topic_id: 1, score: 10)

#Create moderators also
Moderator.create(user_id: 2, organization_id: 2, topic_id: 2)





Post.create(
  body: "Post from akshay_023!",
  user_id: 2,
  q1: "How is everyone today?",
  q1_args: "Good, Bad, Amazing",
  q2: "",
  q2_args: "",
  image_link: "",
  video_link: "",
  is_private: false,
  topic_id: 0,
  organization_id: 2,
  datathing: "",
  form_link: "",
  post_category: "discussion",
  moderation_status: "pending")




Post.create(
  body: "Post from Akshay! Limited Commons.",
  user_id: 1,
  q1: "Question 1?",
  q1_args: "Yes, No, Maybe",
  q2: "Question 2?",
  q2_args: "Yes, No, Maybe",
  image_link: "https://drive.google.com/file/d/1EDVb6A9EJ8j1rahc3oJvrdJua3PSGFN4/view?usp=share_link",
  video_link: "https://youtu.be/QRZ_l7cVzzU?si=fTrE1_Z81LPCPY7s",
  is_private: true,
  topic_id: 0,
  organization_id: 2,
  datathing: "",
  form_link: "",
  post_category: "information",
  moderation_status: "pending"
)


Post.create(
  body: "Idea from Omkar, Ideation!",
  user_id: 3,
  q1: "How are you today?",
  q1_args: "Good, Bad, Meh",
  q1_percentages: "4,0,0",
  q2: "Did you eat today?",
  q2_args: "Yes, No, Maybe",
  q2_percentages: "0,0,4",
  image_link: "",
  video_link: "https://youtu.be/_mKeVGSqQac?si=hMNyip6W5VWhvR1_",
  is_private: false,
  topic_id: 0,
  organization_id: 2,
  datathing: "",
  form_link: "https://docs.google.com/forms/d/e/1FAIpQLSfOtl8F8EYwRov8yWTeFIuHa2Zrk9Yz4v_uz51-BOIB8J4SNw/viewform?usp=sf_link",
  post_category: "idea",
  moderation_status: "pending"
)