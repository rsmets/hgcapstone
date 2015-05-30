task :add_tags => :environment do
	Tag.delete_all
	DataTypeTag.delete_all

	puts "Current amount of tags: #{Tag.all.length}"
	alcohol_and_tobacco = Tag.create(name: "Alcohol and Tobacco")
	alcohol_and_tobacco.data_types.push(DataType.where("
		name ILIKE '%smok%' OR
		name ILIKE '%tobacco%' OR 
		name ILIKE '%liver%' OR
		name ILIKE '%lung%' OR
		name ILIKE '%alcohol%'
	"))

	demography = Tag.create(name: "Demography")
	demography.data_types.push(DataType.where("
		name ILIKE '%health%' OR 
		name ILIKE '%house%' OR 
		name ILIKE '%home%' OR
		name ILIKE '%popul%' OR
		name ILIKE '%life%' OR
		name ILIKE '%liv%' OR
		name ILIKE '%people%' OR
		name ILIKE '%person%' OR
		name ILIKE '%marriage%' OR
		name ILIKE '%marital%' OR
		name ILIKE '%fertil%' OR
		name ILIKE '%male%' OR
		name ILIKE '%migrat%' OR
		name ILIKE '%user%'
	"))

	economy = Tag.create(name: "Economy")
	economy.data_types.push(DataType.where("
		name ILIKE '%gdp%' OR
		name ILIKE '%gnp%' OR
		name ILIKE '%business%' OR
		name ILIKE '%income%' OR
		name ILIKE '%dividend%' OR
		name ILIKE '%invest%' OR
		name ILIKE '%surplus%' OR
		name ILIKE '%deficit%' OR
		name ILIKE '%saving%' OR
		name ILIKE '%save%' OR
		name ILIKE '%consum%' OR
		name ILIKE '%expend%' OR
		name ILIKE '%debt%' OR
		name ILIKE '%revenue%' OR
		name ILIKE '%interest%' OR
		name ILIKE '%employ%' OR
		name ILIKE '%subscri%' OR
		name ILIKE '%econom%' OR
		name ILIKE '%fiscal%' OR
		name ILIKE '%growth%' OR
		name ILIKE '%employ%' OR
		name ILIKE '%export%' OR
		name ILIKE '%import%' OR
		name ILIKE '%inflat%' OR
		name ILIKE '%deflat%' OR
		name ILIKE '%cpi%' OR
		name ILIKE '%work%' OR
		name ILIKE '%educat%' OR
		name ILIKE '%cost%'	
	"))

	energy = Tag.create(name: "Energy")
	energy.data_types.push(DataType.where("
		name ILIKE '%emissions%' OR
		name ILIKE '%fuel%' OR
		name ILIKE '%petrol%' OR
		name ILIKE '%gas%' OR
		name ILIKE '%electric%' OR
		name ILIKE '%chemical%' OR
		name ILIKE '%lighting%' OR
		name ILIKE '%solar%' OR
		name ILIKE '%hydro%' OR
		name ILIKE '%wind%' OR
		name ILIKE '%thermal%' OR
		name ILIKE '%nuclear%' OR
		name ILIKE '%diesel%' OR
		name ILIKE '%coal%' OR
		name ILIKE '%lubricant%' OR
		name ILIKE '%wast%'
	"))

	health = Tag.create(name: "Health")
	health.data_types.push(DataType.where("
		name ILIKE '%health%' OR
		name ILIKE '%life%' OR
		name ILIKE '%liv%' OR
		name ILIKE '%disease%' OR
		name ILIKE '%care%' OR
		name ILIKE '%birth%' OR
		name ILIKE '%mortal%' OR
		name ILIKE '%drug%' OR
		name ILIKE '%overweight%' OR
		name ILIKE '%underweight%' OR
		name ILIKE '%nurse%' OR
		name ILIKE '%matern%' OR
		name ILIKE '%pharm%'
	"))

	housing_and_real_estate = Tag.create(name: "Housing and Real Estate")
	housing_and_real_estate.data_types.push(DataType.where("
		name ILIKE '%home%' OR
		name ILIKE '%house%' OR
		name ILIKE '%build%' OR
		name ILIKE '%construct%' OR
		name ILIKE '%mortgage%' OR
		name ILIKE '%vacan%' OR
		name ILIKE '%fha insure%' OR
		name ILIKE '%va guaranteed%'
	"))

	inflation = Tag.create(name: "Inflation")
	inflation.data_types.push(DataType.where("
		name ILIKE '%inflat%' OR
		name ILIKE '%deflat%' OR
		name ILIKE '%cpi%' OR
		name ILIKE '%cost%'
	"))

	labor_and_unemployment = Tag.create(name: "Labor and Unemployment")
	labor_and_unemployment.data_types.push(DataType.where("
		name ILIKE '%labor%' OR
		name ILIKE '%employ%' OR
		name ILIKE '%labor%' OR
		name ILIKE '%payroll%' OR
		name ILIKE '%job%' OR
		name ILIKE '%prison%' OR
		name ILIKE '%diploma%' OR
		name ILIKE '%degree%' OR
		name ILIKE '%veteran%'
	"))

	population = Tag.create(name: "Population")
	population.data_types.push(DataType.where("
		name ILIKE '%popul%' OR
		name ILIKE '%male%' OR
		name ILIKE '%participat%'
	"))

	society = Tag.create(name: "Society")
	society.data_types.push(DataType.where("
		name ILIKE '%popul%' OR
		name ILIKE '%migrat%' OR
		name ILIKE '%fertil%' OR
		name ILIKE '%birth%' OR
		name ILIKE '%life%' OR
		name ILIKE '%hungry%' OR
		name ILIKE '%hunger%' OR
		name ILIKE '%wast%' OR
		name ILIKE '%overweight%' OR
		name ILIKE '%underweight%' OR
		name ILIKE '%enrol%' OR
		name ILIKE '%water%' OR
		name ILIKE '%disaster%' OR
		name ILIKE '%corrupt%' OR
		name ILIKE '%law%' OR
		name ILIKE '%soci%' OR
		name ILIKE '%user%' OR
		name ILIKE '%vehic%' OR
		name ILIKE '%tour%' OR
		name ILIKE '%work%' OR
		name ILIKE '%educat%' OR
		name ILIKE '%arm%' OR
		name ILIKE '%milita%' OR
		name ILIKE '%person%' OR
		name ILIKE '%people%' OR
		name ILIKE '%marriage%' OR
		name ILIKE '%marital%' OR
		name ILIKE '%matern%'
	"))

	taxes_and_revenue = Tag.create(name: "Taxes and Revenue")
	taxes_and_revenue.data_types.push(DataType.where("
		name ILIKE '%tax%' OR
		name ILIKE '%revenue%' OR
		name ILIKE '%budget%' OR
		name ILIKE '%income%' OR
		name ILIKE '%receipt%'
	"))

	trade = Tag.create(name: "Trade")
	trade.data_types.push(DataType.where("
		name ILIKE '%export%' OR
		name ILIKE '%import%' OR
		name ILIKE '%commodity%' OR
		name ILIKE '%trade%' OR
		name ILIKE '%trading%' OR
		name ILIKE '%opec%'
	"))

	transport_and_travel = Tag.create(name: "Transport and Travel")
	transport_and_travel.data_types.push(DataType.where("
		name ILIKE '%train%' OR
		name ILIKE '%car%' OR
		name ILIKE '%vehic%' OR
		name ILIKE '%transit%' OR
		name ILIKE '%transport%' OR
		name ILIKE '%travel%' OR
		name ILIKE '%rail%' OR
		name ILIKE '%highway%' OR
		name ILIKE '%freeway%' OR
		name ILIKE '%bus%' OR
		name ILIKE '%commut%' OR
		name ILIKE '%amtrak%' OR
		name ILIKE '%truck%' OR
		name ILIKE '%passenger%' OR
		name ILIKE '%plane%' OR
		name ILIKE '%aviation%' OR
		name ILIKE '%freight%' OR
		name ILIKE '%fuel%' OR
		name ILIKE '%motor%' OR
		name ILIKE '%gasoline%' OR
		name ILIKE '%diesel%' OR
		name ILIKE '%automobile%' OR
		name ILIKE '%bike%' OR
		name ILIKE '%bicycle%' OR
		name ILIKE '%walk%' OR
		name ILIKE '%pedestr%' OR
		name ILIKE '%crash%'
	"))
	
	puts "Current amount of tags: #{Tag.all.length}"
end