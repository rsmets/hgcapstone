class DataCorrelationsController < ApplicationController
  before_action :set_data_correlation, only: [:show, :edit, :update, :destroy]

  # GET /data_correlations
  # GET /data_correlations.json
  def index
    @data_correlations = DataCorrelation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @data_correlations }
    end
  end

  # GET /data_correlations/1
  # GET /data_correlations/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @data_correlation }
    end
  end

  # GET /data_correlations/new
  def new
    @data_correlation = DataCorrelation.new
  end

  # GET /data_correlations/1/edit
  def edit
  end

  # POST /data_correlations
  # POST /data_correlations.json
  def create
    @data_correlation = DataCorrelation.new(data_correlation_params)

    respond_to do |format|
      if @data_correlation.save
        format.html { redirect_to @data_correlation, notice: 'Data correlation was successfully created.' }
        format.json { render json: @data_correlation, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @data_correlation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /data_correlations/1
  # PATCH/PUT /data_correlations/1.json
  def update
    respond_to do |format|
      if @data_correlation.update(data_correlation_params)
        format.html { redirect_to @data_correlation, notice: 'Data correlation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @data_correlation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_correlations/1
  # DELETE /data_correlations/1.json
  def destroy
    @data_correlation.destroy
    respond_to do |format|
      format.html { redirect_to data_correlations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_correlation
      @data_correlation = DataCorrelation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def data_correlation_params
      params.require(:data_correlation).permit(:p_coeff, :event1_id, :event2_id)
    end
end
