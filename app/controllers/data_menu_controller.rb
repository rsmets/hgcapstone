class DataMenuController < ApplicationController
  def index
  	
  end

  def pick_data
  	@dt = DataType.all
    @selected_dt = params[:data_id]
  end
  
  def pick_data_submit
    #redirect_to '/data_menu/'+params[:data_id].to_s+'/pick_range'
    redirect_to(action: 'pick_range', data_id: params[:data_id])
  end

  def pick_range
    pick_data
    data_type = DataType.find(params[:data_id]).name
    @data_type = data_type[0..-5] # Remove '.txt'
    data_points = DataPoint.where("event_type_id = ?", params[:data_id].to_i)
    year1 = data_points.first.year
    year2 = data_points.last.year
    @start_year = [year1, year2].min
    @end_year = [year1, year2].max
    @num = params[:num] || @start_year
    @num2 = params[:num2] || @end_year
  end

  def pick_range_submit
    #redirect_to '/data_menu/'+params[:data_id].to_s+'/pick_range/'+params[:num].to_s+'&'+params[:num2].to_s+'/pick_correlation'
    #redirect_to(pick_correlation_path(:data_id, :num, :num2))
    redirect_to(action: 'pick_correlation', data_id: params[:data_id], num: params[:num], num2: params[:num2])

  end

  def pick_correlation
    pick_range

  #    @dt = DataType.where("", params[:data_id].to_i)
    @corrs = DataCorrelation.all
  end
end
