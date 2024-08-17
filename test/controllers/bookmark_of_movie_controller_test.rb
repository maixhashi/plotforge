require "test_helper"

class BookmarkOfMovieControllerTest < ActionDispatch::IntegrationTest
  test "should get bookmark" do
    get bookmark_of_movie_bookmark_url
    assert_response :success
  end

  test "should get unbookmark" do
    get bookmark_of_movie_unbookmark_url
    assert_response :success
  end
end
