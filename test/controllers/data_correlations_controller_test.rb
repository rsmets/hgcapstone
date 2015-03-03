require 'test_helper'

class DataCorrelationsControllerTest < ActionController::TestCase
  setup do
    @data_correlation = data_correlations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:data_correlations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create data_correlation" do
    assert_difference('DataCorrelation.count') do
      post :create, data_correlation: { event1_id: @data_correlation.event1_id, event2_id: @data_correlation.event2_id, p_coeff: @data_correlation.p_coeff }
    end

    assert_redirected_to data_correlation_path(assigns(:data_correlation))
  end

  test "should show data_correlation" do
    get :show, id: @data_correlation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @data_correlation
    assert_response :success
  end

  test "should update data_correlation" do
    patch :update, id: @data_correlation, data_correlation: { event1_id: @data_correlation.event1_id, event2_id: @data_correlation.event2_id, p_coeff: @data_correlation.p_coeff }
    assert_redirected_to data_correlation_path(assigns(:data_correlation))
  end

  test "should destroy data_correlation" do
    assert_difference('DataCorrelation.count', -1) do
      delete :destroy, id: @data_correlation
    end

    assert_redirected_to data_correlations_path
  end
end
