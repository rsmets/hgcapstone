load Rails.root.join('pearson.rb')

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

    # Populate Correlation Table 'DataCorrelation'

    # Clear existing entries in the correlation table
    DataCorrelation.delete_all

    year_param = Array.new

    # USER INPUT: CHANGEABLE PARAMETERS
    input_set_id= params[:data_id].to_i # specifies what input dataset is
    year_param[0] = params[:num] # specifies range of years to perform correlation upon
    year_param[1] = params[:num2]

    # Creating array for input data set with values corresponding to each year in a specified year-range
    # ([] placed in array if no value for a year)
    input = Array.new
    (year_param[0].to_i..year_param[1].to_i).each do |year|
      event= DataPoint.where(event_type_id:input_set_id,year:year).take
      input.push(event[:value])
    end

    # Creating arrays for all other data sets corresponding to each year in a specified year-range
    # ([] placed in array if no value for a year)
    DataType.find_each do |set|
      if set.id != input_set_id
        against = Array.new
        (year_param[0].to_i..year_param[1].to_i).each do |year|
          event = DataPoint.where(event_type_id:set.id,year:year).take
          puts event
          if event == nil
            against.push(nil)
          else
            against.push(event[:value])
          end

        end
        DataCorrelation.create(
        # Performing Pearsons' coefficient on arrays 'input' and 'against'
        p_coeff: pearson(input,against),
        event1_id: input_set_id,
        event2_id: set.id)
      end
    end

      redirect_to(action: 'pick_correlation', data_id: params[:data_id], num: params[:num], num2: params[:num2])

  end

  def pick_correlation
    pick_range

  #    @dt = DataType.where("", params[:data_id].to_i)
    @corrs = DataCorrelation.all
  end

end
