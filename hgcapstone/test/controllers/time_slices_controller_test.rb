require 'test_helper'

class TimeSlicesControllerTest < ActionController::TestCase
  setup do
    @time_slice = time_slices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:time_slices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create time_slice" do
    assert_difference('TimeSlice.count') do
      post :create, time_slice: { population: @time_slice.population, year: @time_slice.year }
    end

    assert_redirected_to time_slice_path(assigns(:time_slice))
  end

  test "should show time_slice" do
    get :show, id: @time_slice
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @time_slice
    assert_response :success
  end

  test "should update time_slice" do
    patch :update, id: @time_slice, time_slice: { population: @time_slice.population, year: @time_slice.year }
    assert_redirected_to time_slice_path(assigns(:time_slice))
  end

  test "should destroy time_slice" do
    assert_difference('TimeSlice.count', -1) do
      delete :destroy, id: @time_slice
    end

    assert_redirected_to time_slices_path
  end
end
