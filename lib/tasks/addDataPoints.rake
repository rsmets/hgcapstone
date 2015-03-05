require_relative "pearson"

task :adddatapoints => :environment do


  # A. Populate Data Sets and Data Points Tables 'DataType' and 'DataPoint'

  puts "Adding USGDPByYear.txt and USPopByYear.txt data"
  
  new_type= DataType.create(name:"USPopByYear.txt", url:"url.com")
  File.open(File.join(Rails.root, 'db', 'USPopByYear.txt')) do |f|
    f.each_line do |l| 
      line = l.split(' ')   
      year = line[2]
      pop = (line[3].to_f*1000000).to_i
      DataPoint.create(
      year:year,
      value:pop,
      event_type_id:new_type.id)
    end
  end

  new_type= DataType.create(name:"USGDPByYear.txt", url:"url.com")
  File.open(File.join(Rails.root, 'db', 'USGDPByYear.txt')) do |f|
    f.each_line do |l| 
      line = l.split(' ')   
      year = line[2]
      gdp = (line[3].to_f*1000000000000).to_i
      DataPoint.create(
      year:year,
      value:gdp,
      event_type_id:new_type.id)
    end
  end


 # B. Populate Correlation Table 'DataCorrelation'

  year_param = Array.new

  # USER INPUT: CHANGEABLE PARAMETERS
  input_set_id= 1 # specifies what input dataset is
  year_param[0] = 1987 # specifies range of years to perform correlation upon
  year_param[1] = 1991

  # Creating array for input data set with values corresponding to each year in a specified year-range
  # ([] placed in array if no value for a year)
  input = Array.new
  (year_param[0].to_i..year_param[1].to_i).each do |year|
    event= DataPoint.where(event_type_id:input_set_id,year:year).take
    input.push(event[:value])
  end

  print "INPUT ARRAY "
  print DataType.find(input_set_id)[:name]
  puts ":"
  puts input

  # Creating arrays for all other data sets corresponding to each year in a specified year-range
  # ([] placed in array if no value for a year)
  DataType.find_each do |set|
    if set.id != input_set_id
      against = Array.new
      (year_param[0].to_i..year_param[1].to_i).each do |year|
        event = DataPoint.where(event_type_id:set.id,year:year).take
        against.push(event[:value])
      end
      DataCorrelation.create(
      # Performing Pearsons' coefficient on arrays 'input' and 'against'
      p_coeff: pearson(input,against),
      event1_id: input_set_id,
      event2_id: set.id)
      
      print "AGAINST ARRAY "
      print DataType.find(set.id)[:name]
      puts ":"
      puts against
    end
  end


end