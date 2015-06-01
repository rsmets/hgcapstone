class AnalyzeController < ApplicationController
  def index
    # Faked, beacuse it isn't actually created in the database
    faked_all_tag = Tag.new(name: 'All')
    faked_all_tag.data_types = DataType.all
    @data_types = DataType.all
    @tags = Tag.all
    @tags.push(faked_all_tag)
  end

  def graph
  	render json: DataPoint.where("(data_type_id = ? OR data_type_id = ?)", params[:id0], params[:id1])
  end
end
