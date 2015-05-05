class UpdateDataPoints < ActiveRecord::Migration
  def change
  	add_column :data_points, :data_type_id, :integer
  end
end
