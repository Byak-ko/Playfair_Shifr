require "test_helper"

class CipherControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cipher_index_url
    assert_response :success
  end

  test "should get encrypt" do
    get cipher_encrypt_url
    assert_response :success
  end

  test "should get decrypt" do
    get cipher_decrypt_url
    assert_response :success
  end
end
