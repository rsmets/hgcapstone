class Tag < ActiveRecord::Base
  default_scope { order(name: :asc) }
  
  # Creates relationships to data_types
  has_many :data_type_tags
  has_many :data_types, through: :data_type_tags
end
