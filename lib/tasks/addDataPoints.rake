require_relative "pearson"
require 'csv'

task :adddatapoints => :environment do


  # A. Populate Data Sets and Data Points Tables 'DataType' and 'DataPoint'
  
  new_type= DataType.create(name:"USPopByYear", url:"url.com")
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

  new_type= DataType.create(name:"USGDPByYear", url:"url.com")
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

  new_type= DataType.create(name:"Smoking_Prevalence_in_Adults__1984-2013_Total)", url:"https://chhs.data.ca.gov/resource/rc67-ecu8.csv")
  new_type2= DataType.create(name:"Smoking_Prevalence_in_Adults__1984-2013_Female)", url:"https://chhs.data.ca.gov/resource/rc67-ecu8.csv")
  new_type3= DataType.create(name:"Smoking_Prevalence_in_Adults__1984-2013_Male)", url:"https://chhs.data.ca.gov/resource/rc67-ecu8.csv")
  num = 1
  CSV.foreach(File.join(Rails.root, 'db', 'Smoking_Prevalence_in_Adults__1984-2013.csv'), headers: true) do |line|    
      year = line[0]
      percent = line[2].to_s
      percent.delete! '%'
    if num%3 == 1
      DataPoint.create(
      year:year,
      value:percent,
      event_type_id:new_type.id)
    elsif num%3 == 2
      DataPoint.create(
      year:year,
      value:percent,
      event_type_id:new_type2.id)
    else
      DataPoint.create(
      year:year,
      value:percent,
      event_type_id:new_type3.id)
    end
    num = num+1
  end

  new_type= DataType.create(name:"Adults_who_have_any_kind_of_health_care_coverage__Trends_for_1995-2010", url:"https://data.cdc.gov/resource/s64v-5nny.csv")
  CSV.foreach(File.join(Rails.root, 'db', 'Adults_who_have_any_kind_of_health_care_coverage__Trends_for_1995-2010.csv'), headers: true) do |line|  
    year = line[0]
    percent = line[2].to_s
    percent.delete! '%'
    DataPoint.create(
    year:year,
    value:percent.to_f,
    event_type_id:new_type.id)
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

      print "AGAINST ARRAY "
      print DataType.find(set.id)[:name]
      puts ":"
      puts against
    end
  end

end