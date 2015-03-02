class GraphController < ApplicationController
 
  def data
    
  	 render :json => TimeSlice.where("year > ? AND year < ?", params[:year], params[:year2])
  	 #render :json => TimeSlice.limit($limit).where("year > ?", params[:year])
  	#render :json => TimeSlice.all
  end

  def index
      	
      	render :index
      
    	
  end

end
