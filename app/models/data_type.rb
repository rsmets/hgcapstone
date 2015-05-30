class DataType < ActiveRecord::Base
  default_scope { order(name: :asc) }

  has_many :datapoints

  # Creates relationships to tags
  has_many :data_type_tags
  has_many :tags, through: :data_type_tags
end
