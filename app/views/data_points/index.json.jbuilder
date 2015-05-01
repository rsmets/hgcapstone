json.array!(@data_points) do |data_point|
  json.extract! data_point, :id, :value_1, :value_2, :value_2_id, value_1_id
  json.url data_point_url(data_point, format: :json)
end
