json.extract! topic, :id, :topic_path, :topic_name, :created_at, :updated_at
json.url topic_url(topic, format: :json)
