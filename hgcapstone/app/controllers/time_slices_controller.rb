class TimeSlicesController < ApplicationController
  before_action :set_time_slice, only: [:show, :edit, :update, :destroy]

  # GET /time_slices
  # GET /time_slices.json
  def index
    @time_slices = TimeSlice.all
  end

  # GET /time_slices/1
  # GET /time_slices/1.json
  def show
  end

  # GET /time_slices/new
  def new
    @time_slice = TimeSlice.new
  end

  # GET /time_slices/1/edit
  def edit
  end

  # POST /time_slices
  # POST /time_slices.json
  def create
    @time_slice = TimeSlice.new(time_slice_params)

    respond_to do |format|
      if @time_slice.save
        format.html { redirect_to @time_slice, notice: 'Time slice was successfully created.' }
        format.json { render :show, status: :created, location: @time_slice }
      else
        format.html { render :new }
        format.json { render json: @time_slice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /time_slices/1
  # PATCH/PUT /time_slices/1.json
  def update
    respond_to do |format|
      if @time_slice.update(time_slice_params)
        format.html { redirect_to @time_slice, notice: 'Time slice was successfully updated.' }
        format.json { render :show, status: :ok, location: @time_slice }
      else
        format.html { render :edit }
        format.json { render json: @time_slice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_slices/1
  # DELETE /time_slices/1.json
  def destroy
    @time_slice.destroy
    respond_to do |format|
      format.html { redirect_to time_slices_url, notice: 'Time slice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_slice
      @time_slice = TimeSlice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def time_slice_params
      params.require(:time_slice).permit(:year, :population)
    end
end
