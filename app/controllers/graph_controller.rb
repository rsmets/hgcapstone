class GraphController < ApplicationController
  
 
  def index
     

        ts = TimeSlice.where(year: 2006)
        ts = ts.map do |time_slice|
        	t = time_slice.to_json
        	t[:events] = time_slice.events.to_json
        	t
        end
        render :json => ts
      	#render :show, status: :created, location: @time_slice
      
    	
  end
end
