require "test_helper"

class ShuffledOverviewsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get shuffled_overviews_create_url
    assert_response :success
  end
end
