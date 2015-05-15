load Rails.root.join('lib/correlations/pearson.rb')
load Rails.root.join('lib/correlations/spearman.rb')
load Rails.root.join('lib/correlations/spearman2.rb')
load Rails.root.join('lib/correlations/pearson2.rb')

class DataTypesCorrelationsController < ActionController::Base
  def create
    do_correlations(params[:id].to_i)
    render json: DataCorrelation.where(event1_id: params[:id])
  end

  def createMatrix # this is for heatmap
    do_correlations_matrix()
    render json: DataCorrelation.all
  end
  
  private

  # Makes a random matrix of data sets with corresponding corelation values.
  def do_correlations_matrix()
    # Populate Correlation Table 'DataCorrelations' of random data sets

    # Clear existing entries in the correlation table
    DataCorrelation.delete_all

    data_sets_y = Array.new #an array of array of data points (aka data sets)
    time_param = Array.new

    # CURRENTLY USING ONLY THE FIRST ~4 DATA SETS
    y_data_set_nums = Array.new
    y_data_set_nums = [*1..8]
    y_data_set_nums.each do |data_set_num|
      time1 = DataPoint.where(data_type_id: data_set_num).first.value_1
      time2 = DataPoint.where(data_type_id: data_set_num).last.value_1
      time_param[0] = [time1, time2].min
      time_param[1] = [time1, time2].max
    

      # Creating array for input data set with values corresponding to each time
      # ([] placed in array if no value for a year)
      data_set_points = Array.new
      
      (time_param[0].to_i..time_param[1].to_i).each do |time|
        event= DataPoint.where(data_type_id:data_set_num,value_1:time).take
        if event == nil
          data_set_points.push(nil)
        else
          data_set_points.push(event[:value_2])
        end
      end

      #adding to the array of data_sets
      data_sets_y.push(data_set_points);
    end

    # Creating arrays for all other data sets corresponding to each year in a specified year-range
    # ([] placed in array if no value for a year)

    x_data_set_nums = Array.new
    data_sets_x = Array.new

    DataType.find_each do |set|
      if x_data_set_nums.size >= y_data_set_nums.size
        break;
      end
      #if found a data set not in the y column data sets
      if !(y_data_set_nums.include? set.id)
        x_data_set_nums.push(set.id)
        against = Array.new
        (time_param[0].to_i..time_param[1].to_i).each do |time|
          event = DataPoint.where(data_type_id:set.id,value_1:time).take
          if event == nil
            against.push(nil)
          else
            against.push(event[:value_2])
          end
        end
        data_sets_x.push(against)
      end
    end

    #at this point theres equal num of data sets in x and y data set arrays
    p_out = pearson2(data_sets_y,data_sets_x)
    s_out = spearman2(data_sets_y,data_sets_x)

    #looping through the multideminsional arrays to set dataCorrelations fields properly
    p_out.each_with_index do |array, index|
      array.each_with_index do |value, index2|
        DataCorrelation.create(
          # Performing Pearsons' coefficient on arrays 'input' and 'against'
          p_coeff: value,
          event1_id: y_data_set_nums[index],
          event2_id: x_data_set_nums[index2])
      end
    end

    #find the DataCorrelation pertaining to the two ids then add s_coeff value
    s_out.each_with_index do |array, index|
      array.each_with_index do |value, index2|
        data = DataCorrelation.where("event1_id = ? and event2_id = ?", y_data_set_nums[index] , x_data_set_nums[index2])
        data.each do |d|
          d.update_attribute(:s_coeff, value)
        end
      end
    end
    
  end

  # Params:
  # input_set_id - specifies what input dataset is
  def do_correlations(input_set_id)
    # Populate Correlation Table 'DataCorrelation'

    # Clear existing entries in the correlation table
    DataCorrelation.delete_all

    year_param = Array.new

    # USER INPUT: CHANGEABLE PARAMETERS
    year1 = DataPoint.where(data_type_id: input_set_id).first.value_1
    year2 = DataPoint.where(data_type_id: input_set_id).last.value_1
    year_param[0] = [year1, year2].min
    year_param[1] = [year1, year2].max

    #year_param[0] = DataPoint.where(event_type_id: input_set_id).last.year # specifies range of years to perform correlation upon
    #year_param[1] = DataPoint.where(event_type_id: input_set_id).first.year

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
    #if !DataCorrelation.exists?(:event1_id => input_set_id)
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
    #end
  end

end
