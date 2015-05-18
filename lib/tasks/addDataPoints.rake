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

  # Tim's CSVDataSets.tar -> Added on May 10th

  # array of time strings valid to be used as time parameters
  time_types= ["Year","year","Date","date"]

  # go through entire CSVDataSets directory and add each fle one-by-one
  Dir.foreach("#{Rails.root}/public/CSVDataSets") do |directory|
    if (directory != ".") && (directory != "..")
      Dir.foreach("#{Rails.root}/public/CSVDataSets/" + directory) do |filename|
        if (filename != ".") && (filename != "..")
          file= "#{Rails.root}/public/CSVDataSets/" + directory + "/" + filename

          filename.slice!(".csv")
          new_type= DataType.create(name: filename, url:"https://www.quandl.com")

          variable_names= Array.new
          time_index= 0

          num1= 0
          CSV.foreach(file) do |line|
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
                if (num2 != time_index) && (var!= nil)
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
                  value_2_id: variable_names[column],
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
  end

  puts "addDataPoints finished. "

end