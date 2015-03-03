json.array!(@data_types) do |data_type|
  json.extract! data_type, :id, :name, :url
  json.url data_type_url(data_type, format: :json)
end
