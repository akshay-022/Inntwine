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
  email: "akshaygiyer@gmail.com",
  password: "Aksh@2211",
  first_name: "Akshay",
  last_name: "Iyer",
  admin: true,
  username: "akshay_023",
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

# Define the path to your CSV file
csv_path = File.join(Rails.root, 'db', 'seed', 'topics.csv')

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

User.create(
email: "agi2108@columbia.edu", first_name: "Akshay", last_name: "Iyer", admin: false, created_at: "2023-12-11 23:29:08.945809000 +0000", updated_at: "2023-12-11 23:29:08.945809000 +0000", username: "akshay_022", is_moderator: false
)