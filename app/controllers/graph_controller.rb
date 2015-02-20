class GraphController < ApplicationController
  
 
  def index
     
        render :json => TimeSlice.where(:year > 2009)
      	#render :show, status: :created, location: @time_slice
      
    
  end
end
