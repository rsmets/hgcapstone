class Correlation < ActiveRecord::Base
  belongs_to :event1, foreign_key: :event1_id, class_name: Event
  belongs_to :event2, foreign_key: :event2_id, class_name: Event
end