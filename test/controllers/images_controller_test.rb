require "test_helper"

class ImagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
  end
  test "show images" do
    get images_path
    assert_response :success
  end
  test "show an image" do
    get "/images/" + (images(:one).id).to_s()
    assert_response :success
  end
  test "delete an image" do
    delete "/images/" + (images(:one).id).to_s()
    assert_response :missing
  end
end
