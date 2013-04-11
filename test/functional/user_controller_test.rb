require 'test_helper'

class UserControllerTest < ActionController::TestCase
  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get process_login" do
    get :process_login
    assert_response :success
  end

  test "should get logout" do
    get :logout
    assert_response :success
  end

  test "should get my_account" do
    get :my_account
    assert_response :success
  end

end
