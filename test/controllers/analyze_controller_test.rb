require 'test_helper'

class AnalyzeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
