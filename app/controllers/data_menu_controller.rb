class DataMenuController < ApplicationController
  def index
  	
  end

  def pick_data
  	@dt = DataType.all
  end

  def pick_range
  	data_type = DataType.find(params[:data_id]).name
  	@data_type = data_type[0..-5] # Remove '.txt'
  	data_points = DataPoint.where("event_type_id = ?", params[:data_id].to_i)
  	year1 = data_points.first.year
  	year2 = data_points.last.year
  	@start_year = [year1, year2].min
  	@end_year = [year1, year2].max
  end

  def pick_correlations 

  end
end
