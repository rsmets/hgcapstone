load Rails.root.join('pearson.rb')
load Rails.root.join('spearman.rb')

require 'csv'

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
    @data_type = DataType.find(params[:data_id]).name
    #@data_type = data_type[0..-5] # Remove '.txt'
    data_points = DataPoint.where("data_type_id = ?", params[:data_id].to_i)
    year1 = data_points.first.value_1
    year2 = data_points.last.value_1
    @start_year = [year1, year2].min
    @end_year = [year1, year2].max
    @num = params[:num] || @start_year
    @num2 = params[:num2] || @end_year
  end

  def do_correlations
    # Populate Correlation Table 'DataCorrelation'

    # Clear existing entries in the correlation table
    # DataCorrelation.delete_all

    year_param = Array.new

    # USER INPUT: CHANGEABLE PARAMETERS
    input_set_id= params[:data_id].to_i # specifies what input dataset is
    year_param[0] = params[:num] # specifies range of years to perform correlation upon
    year_param[1] = params[:num2]

    # Creating array for input data set with values corresponding to each year in a specified year-range
    # ([] placed in array if no value for a year)
    input = Array.new
    (year_param[0].to_i..year_param[1].to_i).each do |year|
      event= DataPoint.where(data_type_id:input_set_id,value_1:year).take
      if event == nil
        input.push(nil)
      else  
        input.push(event[:value_2])
      end
    end

    # Creating arrays for all other data sets corresponding to each year in a specified year-range
    # ([] placed in array if no value for a year)
    if !DataCorrelation.exists?(:event1_id => input_set_id)
    DataType.find_each do |set|
      if set.id != input_set_id
        against = Array.new
        (year_param[0].to_i..year_param[1].to_i).each do |year|
          event = DataPoint.where(data_type_id:set.id,value_1:year).take
          if event == nil
            against.push(nil)
          else
            against.push(event[:value_2])
          end

        end
        DataCorrelation.create(
        # Performing Pearsons' coefficient on arrays 'input' and 'against'
        p_coeff: pearson(input,against),
        s_coeff: spearman(input,against),
        event1_id: input_set_id,
        event2_id: set.id)
      end
    end
    end

  end

  def pick_range_submit
    redirect_to(action: 'pick_correlation', data_id: params[:data_id], num: params[:num], num2: params[:num2])
  end

  def pick_correlation_submit
    redirect_to(action: 'draw_graph', data_id: params[:data_id], num: params[:num], num2: params[:num2], data_id2: params[:data_id2])
  end

  def pick_correlation
    pick_range
    do_correlations
    @corrs = DataCorrelation.all
    @dt2 = DataType.where.not(id: @selected_dt)
    @dt2_corrs = @dt2.zip(@corrs)
    @selected_dt2 = params[:data_id2]
  end

  def event_id
    render :json => DataType.find(params[:data_type_id])
  end

  def draw_graph
    pick_correlation
    @data_type2 = DataType.find(params[:data_id2]).name

    @selected_dt2 = params[:data_id2]
    @selected_dt = params[:data_id]
    
  end

  def data
    pick_correlation
    render :json => DataPoint.where("(data_type_id = ? OR data_type_id = ?) AND (value_1 >= ? AND value_1 <= ?)", @selected_dt , @selected_dt2 , @num , @num2 )
    
  end


  def upload_file
    # array of time strings valid to be used as time parameters
    time_types= ["Year","year","Date","date"]

    if params[:new_file]!= nil

      @file = params[:new_file]
      puts @file.original_filename

      variable_names= Array.new
      variable_index= Array.new
      time_index= 0

      new_type= DataType.create(name: @file.original_filename, url:"USER INPUT FILE")

      num1= 0
      CSV.foreach(@file.path) do |line|
        num2 = 0
        line.each do |var|
          if num1 == 0
            if time_types.include?var
              time_index= num2
              index= time_types.index(var)
              @time_name= time_types[index]
            else
              variable = ValueType.create(name: var)
              variable_names.push(variable.id)
            end
          else
            if num2 != time_index
              if time_index < num2
                column= num2-1
              else
                column= num2
              end
              #var= var.gsub(/[^0-9,.]/, '')
              instance= ValueType.where(name: @time_name).take
              if instance== nil
                instance= ValueType.create(name: @time_name)
              end
              DataPoint.create(
              value_1:line[time_index],
              value_1_id:instance.id,
              value_2:var.to_f,
              value_2_id:variable_names[column],
              data_type_id:new_type.id)

            end
          end
          num2= num2+1
        end 
        num1= 1
      end

    end
  end




end
