class DataMenuController < ApplicationController
  def index
  	@ts = TimeSlice.all
  end
end
