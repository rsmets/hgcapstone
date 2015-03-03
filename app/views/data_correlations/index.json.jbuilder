json.array!(@data_correlations) do |data_correlation|
  json.extract! data_correlation, :id, :p_coeff, :event1_id, :event2_id
  json.url data_correlation_url(data_correlation, format: :json)
end
