# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

TimeSlice.delete_all
File.open(File.join(Rails.root, 'db', 'USPopByYear.txt')) do |f|
	f.each_line do |l| 
		line = l.split(' ')		
		year = line[2]
		pop = (line[3].to_f*1000000).to_i
		#puts year + ' ' + pop.to_s
		TimeSlice.create(:year => year, :population => pop)
	end
end