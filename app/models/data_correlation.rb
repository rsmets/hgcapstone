class DataCorrelation < ActiveRecord::Base
  belongs_to :datapoint1, foreign_key: :event1_id, class_name: DataPoint
  belongs_to :datapoint2, foreign_key: :event2_id, class_name: DataPoint
end
