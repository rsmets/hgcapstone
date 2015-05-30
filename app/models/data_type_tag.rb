class DataTypeTag < ActiveRecord::Base
  belongs_to :tag
  belongs_to :data_type
end
