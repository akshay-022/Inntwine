require 'csv'
csv_path = File.join(Rails.root, 'db', 'seed', 'Topics.csv')
# Read CSV and populate topics table
CSV.foreach(csv_path, headers: true) do |row|
  parent_id = row['parent_id'] == 'nil' ? nil : row['parent_id'].to_i
  if row['id'].to_i >= 153
    Topic.create!(
      id: row['id'].to_i,
      topic_path: row['topic_path'],
      topic_name: row['topic_name'],
      parent_id: parent_id
    )
  end
end