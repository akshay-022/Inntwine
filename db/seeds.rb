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
