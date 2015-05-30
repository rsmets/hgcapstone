class DataCorrelationSerializer < ActiveModel::Serializer
  attributes :id, :s_coeff, :p_coeff, :k_coeff, :event1_id, :event2_id
  has_one :data_type1
  has_one :data_type2
end
