class TimeSliceSerializer < ActiveModel::Serializer
  attributes :id, :population, :year, :gdp
  has_many :events
end
