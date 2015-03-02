class AddGdpToTimeSlices < ActiveRecord::Migration
  def change
    add_column :time_slices, :gdp, :bigint
  end
end
