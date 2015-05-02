require 'csv'

task :adddatapoints => :environment do

  #creating the unique value types.
  #if adding a set with similar values use these types. if not create a new one below.
  years_value_type = ValueType.create(name:"Years")
  num_ppl_value_type = ValueType.create(name:"Number of People")
  dollars_value_type = ValueType.create(name:"US Dollars")
  percentage_value_type = ValueType.create(name:"Percentage")

  # A. Populate Data Sets and Data Points Tables 'DataType' and 'DataPoint'
  new_data_type= DataType.create(name:"US Pop by Year", url:"url.com")
  File.open(File.join(Rails.root, 'db', 'USPopByYear.txt')) do |f|
    f.each_line do |l| 
      line = l.split(' ')   
      year = line[2]
      pop = (line[3].to_f*1000000).to_i
      DataPoint.create(
      value_1:year,
      value_1_id:years_value_type.id,
      value_2:pop,
      value_2_id:num_ppl_value_type.id,
      data_type_id:new_data_type.id)
    end
  end

  new_data_type= DataType.create(name:"US GDP by Year", url:"url.com")
  File.open(File.join(Rails.root, 'db', 'USGDPByYear.txt')) do |f|
    f.each_line do |l| 
      line = l.split(' ')   
      year = line[2]
      gdp = (line[3].to_f*1000000000000).to_i
      DataPoint.create(
      value_1:year,
      value_1_id:years_value_type.id,
      value_2:gdp,
      value_2_id:dollars_value_type.id,
      data_type_id:new_data_type.id)
    end
  end

  new_data_type= DataType.create(name:"Smoking Prevalence in Adults Total", url:"https://chhs.data.ca.gov/resource/rc67-ecu8.csv")
  new_data_type2= DataType.create(name:"Smoking Prevalence in Adults Female", url:"https://chhs.data.ca.gov/resource/rc67-ecu8.csv")
  new_data_type3= DataType.create(name:"Smoking Prevalence in Adults Male", url:"https://chhs.data.ca.gov/resource/rc67-ecu8.csv")
  num = 1
  CSV.foreach(File.join(Rails.root, 'db', 'Smoking_Prevalence_in_Adults__1984-2013.csv'), headers: true) do |line|    
      year = line[0]
      percent = line[2].to_s
      percent.delete! '%'
    if num%3 == 1
      DataPoint.create(
      value_1:year,
      value_1_id:years_value_type.id,
      value_2:percent,
      value_2_id:percentage_value_type.id,
      data_type_id:new_data_type.id)
    elsif num%3 == 2
      DataPoint.create(
      value_1:year,
      value_1_id:years_value_type.id,
      value_2:percent,
      value_2_id:percentage_value_type.id,
      data_type_id:new_data_type2.id)
    else
      DataPoint.create(
      value_1:year,
      value_1_id:years_value_type.id,
      value_2:percent,
      value_2_id:percentage_value_type.id,
      data_type_id:new_data_type3.id)
    end
    num = num+1
  end

  new_data_type= DataType.create(name:"Adults Health Care Coverage", url:"https://data.cdc.gov/resource/s64v-5nny.csv")
  CSV.foreach(File.join(Rails.root, 'db', 'Adults_who_have_any_kind_of_health_care_coverage__Trends_for_1995-2010.csv'), headers: true) do |line|  
    year = line[0]
    percent = line[2].to_s
    percent.delete! '%'
    DataPoint.create(
    value_1:year,
    value_1_id:years_value_type.id,
    value_2:percent.to_f,
    value_2_id:percentage_value_type.id,
    data_type_id:new_data_type.id)
  end

  new_data_type = DataType.create(name:"Nintendo Dividends", url:"http://real-chart.finance.yahoo.com/table.csv?s=NTDOY&a=11&b=31&c=1994&d=11&e=31&f=2015&g=v&ignore=.csv")
  CSV.foreach(File.join(Rails.root, 'db', 'ntdoy_dividends.csv'), headers: true) do |line|
    date = line[0]
    year = date[0..3]
    dividend = line[1]
    DataPoint.create(
      value_1: year,
      value_1_id:years_value_type.id,
      value_2: dividend.to_f,
      value_2_id:dollars_value_type.id,
      data_type_id:new_data_type.id)
  end

  new_data_type = DataType.create(name:"Sony Dividends", url:"http://real-chart.finance.yahoo.com/table.csv?s=SNE&a=06&b=26&c=1974&d=03&e=21&f=2015&g=v&ignore=.csv")
  CSV.foreach(File.join(Rails.root, 'db', 'sne_dividends.csv'), headers: true) do |line|
    date = line[0]
    year = date[0..3]
    dividend = line[1]
    DataPoint.create(
      value_1: year,
      value_1_id:years_value_type.id,
      value_2: dividend.to_f,
      value_2_id:dollars_value_type.id,
      data_type_id:new_data_type.id)
  end
end