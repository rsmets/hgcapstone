json.array!(@events) do |event|
  json.extract! event, :id, :month, :year, :event_type_id
  json.url event_url(event, format: :json)
end
