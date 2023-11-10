require "test_helper"

class Public::InformActivitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_inform_activities_index_url
    assert_response :success
  end
end
