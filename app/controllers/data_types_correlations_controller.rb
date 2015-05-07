load Rails.root.join('pearson.rb')
load Rails.root.join('spearman.rb')

class DataTypesCorrelationsController < ActionController::Base
  def create
    do_correlations(params[:id].to_i)
    render json: DataCorrelation.where(event1_id: params[:id])
  end

  private

  # Params:
  # input_set_id - specifies what input dataset is
  def do_correlations(input_set_id)
    # Populate Correlation Table 'DataCorrelation'

    puts "====================================="
    puts input_set_id
    # Clear existing entries in the correlation table
    DataCorrelation.delete_all

    year_param = Array.new

    # USER INPUT: CHANGEABLE PARAMETERS
    year_param[0] = DataPoint.where(data_type_id: input_set_id).last.value_1 # specifies range of years to perform correlation upon
    year_param[1] = DataPoint.where(data_type_id: input_set_id).first.value_1

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
