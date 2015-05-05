class DataPoint < ActiveRecord::Base
  belongs_to :data_type
  belongs_to :value_type
end
