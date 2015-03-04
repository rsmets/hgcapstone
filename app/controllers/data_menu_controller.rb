class DataMenuController < ApplicationController
  def index
  	@dt = DataType.all
  end
end
