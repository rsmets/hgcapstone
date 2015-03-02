# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

rows = {}
startYear = 1900
endYear = 2015
for year in startYear..endYear
	rows[year.to_s] = {:population => nil, :gdp => nil}
end

File.open(File.join(Rails.root, 'db', 'USPopByYear.txt')) do |f|
	f.each_line do |l| 
		line = l.split(' ')		
		year = line[2]
		pop = (line[3].to_f*1000000).to_i
		#puts year + ' ' + pop.to_s
		#puts rows[year.to_s]
		rows[year.to_s][:population] = pop
		#puts rows[year][:population]
	end
end

File.open(File.join(Rails.root, 'db', 'USGDPByYear.txt')) do |f|
	f.each_line do |l|
		line = l.split(' ')
		year = line[2]
		gdp = (line[3].to_f*1000000000000).to_i
		rows[year.to_s][:gdp] = gdp
	end
end

TimeSlice.delete_all
for year in startYear..endYear
	pop = rows[year.to_s][:population]
	gdp = rows[year.to_s][:gdp]
	TimeSlice.create(:year => year, :population => pop, :gdp => gdp)
end

#puts rows
#Event.delete_all
#Event.create(name: 'Christmas', description: "Merry Christmas!", time_slice: TimeSlice.where(year: 2006).first)