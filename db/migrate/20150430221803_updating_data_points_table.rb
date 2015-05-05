class UpdatingDataPointsTable < ActiveRecord::Migration
  def change
  	rename_column :data_points, :value, :value_2
  	rename_column :data_points, :year, :value_1
  	rename_column :data_points, :event_type_id, :value_2_id
  	add_column :data_points, :value_1_id, :integer
  end
end
