class DataCorrelation < ActiveRecord::Base
  belongs_to :data_type1, foreign_key: :event1_id, class_name: DataType
  belongs_to :data_type2, foreign_key: :event2_id, class_name: DataType
end
