require 'test_helper'

class DataPointsControllerTest < ActionController::TestCase
  setup do
    @data_point = data_points(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:data_points)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create data_point" do
    assert_difference('DataPoint.count') do
      post :create, data_point: { data_type_id: @data_point.data_type_id, value_2: @data_point.value_2, value_1: @data_point.value_1 }
    end

    assert_redirected_to data_point_path(assigns(:data_point))
  end

  test "should show data_point" do
    get :show, id: @data_point
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @data_point
    assert_response :success
  end

  test "should update data_point" do
    patch :update, id: @data_point, data_point: { data_type_id: @data_point.data_type_id, value_2: @data_point.value_2, value_1: @data_point.value_1 }
    assert_redirected_to data_point_path(assigns(:data_point))
  end

  test "should destroy data_point" do
    assert_difference('DataPoint.count', -1) do
      delete :destroy, id: @data_point
    end

    assert_redirected_to data_points_path
  end
end
