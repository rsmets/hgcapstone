class AnalyzeController < ApplicationController
  def index
    @data_types = DataType.all
  end

  def graph
  	render json: DataPoint.where("(data_type_id = ? OR data_type_id = ?)", params[:id0], params[:id1])
  end
end
