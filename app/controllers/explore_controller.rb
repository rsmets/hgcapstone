class ExploreController < ApplicationController
  def index
	  @data_types = DataType.all
  end
end
