class GraphController < ApplicationController
  
  def data

  	 render :json => TimeSlice.limit(params[:limit]).where("year > ?", params[:year])
  	#render :json => TimeSlice.all
  end

  def index
      	
      	render :index
      
    	
  end

  def graph
  	render :data
  end
end
