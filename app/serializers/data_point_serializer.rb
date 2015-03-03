class DataPointSerializer < ActiveModel::Serializer
  attributes :id, :year, :value, :event_type_id
end
