require 'csv'

task :adddatapoints => :environment do


  # A. Populate Data Sets and Data Points Tables 'DataType' and 'DataPoint'
  
  new_type= DataType.create(name:"US Pop by Year", url:"url.com")
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

  new_type= DataType.create(name:"US GDP by Year", url:"url.com")
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

  new_type= DataType.create(name:"Smoking Prevalence in Adults Total", url:"https://chhs.data.ca.gov/resource/rc67-ecu8.csv")
  new_type2= DataType.create(name:"Smoking Prevalence in Adults Female", url:"https://chhs.data.ca.gov/resource/rc67-ecu8.csv")
  new_type3= DataType.create(name:"Smoking Prevalence in Adults Male", url:"https://chhs.data.ca.gov/resource/rc67-ecu8.csv")

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
    end
    num = num+1
  end

  num = 1
  CSV.foreach(File.join(Rails.root, 'db', 'Smoking_Prevalence_in_Adults__1984-2013.csv'), headers: true) do |line|    
      year = line[0]
      percent = line[2].to_s
      percent.delete! '%'
    if num%3 == 2
      DataPoint.create(
      year:year,
      value:percent,
      event_type_id:new_type2.id)
    end
    num = num+1
  end

  num = 1
  CSV.foreach(File.join(Rails.root, 'db', 'Smoking_Prevalence_in_Adults__1984-2013.csv'), headers: true) do |line|    
      year = line[0]
      percent = line[2].to_s
      percent.delete! '%'
      if num%3 == 0
      DataPoint.create(
      year:year,
      value:percent,
      event_type_id:new_type3.id)
    end
    num = num+1
  end

  new_type= DataType.create(name:"Adults Health Care Coverage", url:"https://data.cdc.gov/resource/s64v-5nny.csv")
  CSV.foreach(File.join(Rails.root, 'db', 'Adults_who_have_any_kind_of_health_care_coverage__Trends_for_1995-2010.csv'), headers: true) do |line|  
    year = line[0]
    percent = line[2].to_s
    percent.delete! '%'
    DataPoint.create(
    year:year,
    value:percent.to_f,
    event_type_id:new_type.id)
  end

end