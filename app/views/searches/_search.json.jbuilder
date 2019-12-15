json.extract! search, :id, :category, :title, :url, :description, :created_at, :updated_at
json.url search_url(search, format: :json)
