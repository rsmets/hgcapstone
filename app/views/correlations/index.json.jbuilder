json.array!(@correlations) do |correlation|
  json.extract! correlation, :id, :coefficient, :event1_id, :event2_id
  json.url correlation_url(correlation, format: :json)
end
