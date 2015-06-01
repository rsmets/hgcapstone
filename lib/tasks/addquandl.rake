require 'csv'
require 'nokogiri'
require 'json'
require 'open_uri_redirections'

def upload_file(url,name,filename,tag_id)

  # array of time strings valid to be used as time parameters
  time_types= ["Date","date"]

  csv_file= open(url).read()

  variable_names= Array.new
  time_index= -1

  new_type= DataType.create(name: name, url: filename)
  tag_oject = DataTypeTag.create(tag_id: tag_id, data_type_id: new_type.id)

  num1= 0
  year= -1
  CSV.parse(csv_file) do |line|
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
          if year!= line[time_index]
	        #var= var.gsub(/[^0-9,.]/, '')
	        instance= ValueType.where(name: @time_name).take
	        if instance== nil
	          instance= ValueType.create(name: @time_name)
	        end
	        begin
		        DataPoint.create(
		        value_1:line[time_index],
		        value_1_id:instance.id,
		        value_2:var.to_f,
	         	value_2_id:variable_names[column],
	         	data_type_id:new_type.id)
	         	year= line[time_index]
	         rescue
	         	puts "Active Record Error. Skipping."
	         end

          end
          
        end
      end
      num2= num2+1
    end 
    num1= 1
  end

return new_type.id

end



task :addquandl => :environment do

page = Nokogiri::HTML(open("https://www.quandl.com/collections"))

# text of the first <p> element -> JSON object of menu
need_json= page.css('p')[0].text
menu_hash= JSON.parse(need_json)

# go down the menu hierarchy until a URL/hash 'slug' is found
# See www.quandl.com/collections under "Countries"
# menu_hash_index= 0 -> "Countries"

# Specify country name in "tag_name" to download datasets in chunks
menu_hash_index= 0
tag_name= "USA"

menu_hash[menu_hash_index]["children"].each do |children|

	if children.has_key?("slug")
	#	if(grand_children["slug"]=="usa/usa-startups-venture-capital")	# debugging cases
		filename= "https://www.quandl.com/collections/" + children["slug"]
		page = Nokogiri::HTML(open(filename))

		@header= nil
		@name= nil
		categories= Array.new
		page.css("noscript").children.each do |node|
		    if node.name == "h2"
		    	@header= node.text
		  	elsif (node.name == "table") && (@header != nil)
		  		puts
		  		puts "HEADER FOUND: " + @header
		  		puts
		  		data_types= Array.new
		  		node.css("a").each do |element|
		  			if (element.text.strip != 'CSV') && (element.text.strip != 'JSON') && !element["href"].include?("graph")
						if (element["href"].include?("http")) && (!element["href"].include?("quandl.com"))
							puts "ERROR: Invalid URL."
							next
						elsif !element["href"].include?("quandl.com")
							@filename= "https://www.quandl.com" + element["href"]
							puts "Source url: " + @filename
						else
							@filename= element["href"]
						end

						begin
							page = Nokogiri::HTML(open(@filename, :allow_redirections => :all)) do
								found= 0
								page.css("tr td").each do |field|
									if found== 1
										@name= field.text
										found= 0
										puts "Dataset Name: " + field.text
									elsif field.text == "Dataset Name"
										found= 1
									end
								end
								page.css("ul > li").each do |field|
									if field.text.include?("Quandl Code: ")
										api_entry= field.text
										api_entry.slice!("Quandl Code: ")
										@url= "https://www.quandl.com/api/v1/datasets/" + api_entry + ".csv?auth_token=YfQsW7NfpRMVWynRNbXT"
										#puts "CSV URL: " + @url

										# check not already in database -> store in database
										if DataType.exists?(url: @filename)
											puts @name + " already in database."
										else
							  				
							  				@id= upload_file(@url,@name,@filename,@tag_object.id)
						  					data_types.push(@id)
						  					#data_types.push(0)
						  					puts @name + " successfully stored in database."
							  			end

									end
								end
							end


						rescue OpenURI::HTTPError => e
							if e.message == '404 Not Found'
								puts 'ERROR: 404 Not Found.'
							else
								puts "ERROR: File Opening Error."
							end
							next
						end

		  			end
		  		end

		  		
		  		if categories.length == 0
		  			categories.push({"name" => @header,"data_types" => data_types})
		  		elsif categories[-1]["name"]== @header
		  			categories[-1]["data_types"]= categories[-1]["data_types"] + data_types
		  		elsif data_types.length != 0
		  			categories.push({"name" => @header,"data_types" => data_types})
		  		end

		  	end
	  	end
	  	# update JSON menu_hash[index] with hash arrays containing a category and its corresponing data_type IDs
	  	grand_children["categories"]= categories

	  	#end	# debugging cases
	end


	children["children"].each do |grand_children|
		if !grand_children["label"].eql?(tag_name)
			next
		end

		if grand_children.has_key?("children")
			grand_children['children'].each do |great_grand_children|
				puts "NEW TAG NAME: "

				# if(grand_children["slug"]=="usa/usa-startups-venture-capital")	# debugging cases
				filename= "https://www.quandl.com/collections/" + great_grand_children["slug"]
				tag= grand_children["label"] + ": " + great_grand_children["label"]
				puts tag
				@tag_object = Tag.create(name: tag)

				page = Nokogiri::HTML(open(filename))

				@header= nil
				@name= nil
				categories= Array.new
				page.css("noscript").children.each do |node|
				    if node.name == "h2"
				    	@header= node.text
				  	elsif (node.name == "table") && (@header != nil)
				  		puts
				  		puts "HEADER FOUND: " + @header
				  		puts
				  		data_types= Array.new
				  		node.css("a").each do |element|
				  			if (element.text.strip != 'CSV') && (element.text.strip != 'JSON') && !element["href"].include?("graph")
								if (((element["href"].include?("http")) && (!element["href"].include?("quandl.com"))) || (element["href"].include?("quandl.com/collections")))
									puts "ERROR: Invalid URL."
									next
								elsif !element["href"].include?("quandl.com")
									@filename= "https://www.quandl.com" + element["href"]
									puts "Source url: " + @filename
								else
									@filename= element["href"]
								end

								begin
									page = Nokogiri::HTML(open(@filename, :allow_redirections => :all)) do
										found= 0
										page.css("tr td").each do |field|
											if found== 1
												@name= field.text
												found= 0
												puts "Dataset Name: " + field.text
											elsif field.text == "Dataset Name"
												found= 1
											end
										end
										page.css("ul > li").each do |field|
											if field.text.include?("Quandl Code: ")
												api_entry= field.text
												api_entry.slice!("Quandl Code: ")
												@url= "https://www.quandl.com/api/v1/datasets/" + api_entry + ".csv?auth_token=YfQsW7NfpRMVWynRNbXT"
												#puts "CSV URL: " + @url

												# check not already in database -> store in database
												if DataType.exists?(url: @filename)
													puts @name + " already in database."
												else
									  				
									  				@id= upload_file(@url,@name,@filename,@tag_object.id)
								  					data_types.push(@id)
								  					#data_types.push(0)
								  					puts @name + " successfully stored in database."
									  			end

											end
										end
									end


								rescue OpenURI::HTTPError => e
									if e.message == '404 Not Found'
										puts 'ERROR: 404 Not Found.'
									else
										puts "ERROR: File Opening Error."
									end
									next
								end

				  			end
				  		end

				  		
				  		if categories.length == 0
				  			categories.push({"name" => @header,"data_types" => data_types})
				  		elsif categories[-1]["name"]== @header
				  			categories[-1]["data_types"]= categories[-1]["data_types"] + data_types
				  		elsif data_types.length != 0
				  			categories.push({"name" => @header,"data_types" => data_types})
				  		end

				  	end
			  	end
			  	# update JSON menu_hash[index] with hash arrays containing a category and its corresponing data_type IDs
			  	grand_children["categories"]= categories

			  	#end	# debugging cases
			end



		else
#			if(grand_children["slug"]=="usa/usa-startups-venture-capital")	# debugging cases
			filename= "https://www.quandl.com/collections/" + grand_children["slug"]
			page = Nokogiri::HTML(open(filename))

			@header= nil
			@name= nil
			categories= Array.new
			page.css("noscript").children.each do |node|
			    if node.name == "h2"
			    	@header= node.text
			  	elsif (node.name == "table") && (@header != nil)
			  		puts
			  		puts "HEADER FOUND: " + @header
			  		puts
			  		data_types= Array.new
			  		node.css("a").each do |element|
			  			if (element.text.strip != 'CSV') && (element.text.strip != 'JSON') && !element["href"].include?("graph")
							if (element["href"].include?("http")) && (!element["href"].include?("quandl.com"))
								puts "ERROR: Invalid URL."
								next
							elsif !element["href"].include?("quandl.com")
								@filename= "https://www.quandl.com" + element["href"]
								puts "Source url: " + @filename
							else
								@filename= element["href"]
							end

							begin
								page = Nokogiri::HTML(open(@filename, :allow_redirections => :all)) do
									found= 0
									page.css("tr td").each do |field|
										if found== 1
											@name= field.text
											found= 0
											puts "Dataset Name: " + field.text
										elsif field.text == "Dataset Name"
											found= 1
										end
									end
									page.css("ul > li").each do |field|
										if field.text.include?("Quandl Code: ")
											api_entry= field.text
											api_entry.slice!("Quandl Code: ")
											@url= "https://www.quandl.com/api/v1/datasets/" + api_entry + ".csv?auth_token=YfQsW7NfpRMVWynRNbXT"
											#puts "CSV URL: " + @url

											# check not already in database -> store in database
											if DataType.exists?(url: @filename)
												puts @name + " already in database."
											else
								  				
								  				@id= upload_file(@url,@name,@filename,@tag_object.id)
								  				data_types.push(@id)
								  				#data_types.push(0)
								  				puts @name + " successfully stored in database."
								  			end

										end
									end
								end


							rescue OpenURI::HTTPError => e
								if e.message == '404 Not Found'
									puts 'ERROR: 404 Not Found.'
								else
									puts "ERROR: File Opening Error."
								end
								next
							end

			  			end
			  		end

			  		
			  		if categories.length == 0
			  			categories.push({"name" => @header,"data_types" => data_types})
			  		elsif categories[-1]["name"]== @header
			  			categories[-1]["data_types"]= categories[-1]["data_types"] + data_types
			  		elsif data_types.length != 0
			  			categories.push({"name" => @header,"data_types" => data_types})
			  		end

			  	end
		  	end
		  	# update JSON menu_hash[index] with hash arrays containing a category and its corresponing data_type IDs
		  	grand_children["categories"]= categories

		  	#end	# debugging cases
		end
	end
end

# write JSON result to file called menu_hash_(menu_hash_index) in this directory
f_name= "menu_hash_" + menu_hash_index.to_s + ".rb"
File.open(File.join(Rails.root, 'lib/tasks', f_name), 'w+') do |f|
  f.puts menu_hash[menu_hash_index]
end

puts "\nSUCCESS! ADDQUANDL " + "menu_hash[" + menu_hash_index.to_s + "]" + " FINISHED. See " + "menu_hash_" + menu_hash_index.to_s + ".rb" + " in /lib/tasks"

end