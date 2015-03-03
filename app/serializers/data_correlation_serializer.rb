class DataCorrelationSerializer < ActiveModel::Serializer
  attributes :id, :p_coeff, :event1_id, :event2_id
end
