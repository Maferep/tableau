require "test_helper"

class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup { @user = User.take }


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
  test "accepts valid image upload" do
    sign_in_as(User.take)

    assert_difference("Image.count") do
      post images_url, params: {
        image: {
          name: "David upload",
          content: Rack::Test::UploadedFile.new(
            Rails.root.join("test/fixtures/files/david.png"),
            "image/png"
          )
        }
      }
    end

    assert_response :found
  end

  # claude:
  test "rejects a 0 byte image upload" do
    sign_in_as(User.take)
    empty_file = Tempfile.new(["empty", ".jpg"])
    # deliberately write nothing -> 0 bytes on disk

    assert_no_difference("Image.count") do
      post images_url, params: {
        image: {
          name: "Empty upload",
          content: Rack::Test::UploadedFile.new(empty_file.path, "image/jpeg", original_filename: "empty.jpg")
        }
      }
    end

    assert_response :unprocessable_entity
  ensure
    empty_file.close
    empty_file.unlink
  end
end