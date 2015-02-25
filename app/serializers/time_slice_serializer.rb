class TimeSliceSerializer < ActiveModel::Serializer
  attributes :id, :population, :year
  has_many :events
end
