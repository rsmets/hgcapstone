json.array!(@time_slices) do |time_slice|
  json.extract! time_slice, :id, :year, :population
  json.url time_slice_url(time_slice, format: :json)
end
