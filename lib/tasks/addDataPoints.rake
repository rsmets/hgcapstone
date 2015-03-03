task :adddatapoints => :environment do

  puts "Adding USGDPByYear.txt and USPopByYear.txt"
  
  id= 1
  DataType.create(name:"USPopByYear.txt", url:"url.com")
  File.open(File.join(Rails.root, 'db', 'USPopByYear.txt')) do |f|
    f.each_line do |l| 
      line = l.split(' ')   
      year = line[2]
      pop = (line[3].to_f*1000000).to_i
      DataPoint.create(year:year, value:pop, event_type_id:id)
    end
  end

  id= id+1
  DataType.create(name:"USGDPByYear.txt", url:"url.com")
  File.open(File.join(Rails.root, 'db', 'USPopByYear.txt')) do |f|
    f.each_line do |l| 
      line = l.split(' ')   
      year = line[2]
      gdp = (line[3].to_f*1000000000000).to_i
      DataPoint.create(year:year, value:gdp, event_type_id:id)
    end
  end


=begin
  # Populate correlations
  (0..100).each do |i|
    # events = Event.where(decade: decades.to_a.sample )
    events = Event.where(year: years.to_a.sample )
    event1, event2 = events.to_a.sample(2)
    Correlation.create(
      coefficient: rand(100),
      event1: event1,
      event2: event2
    )
  end
=end

end