json.extract! connection, :id, :followed_id, :follower_id, :mutual, :created_at, :updated_at
json.url connection_url(connection, format: :json)
