require 'test_helper'

class CompanydescriptionsControllerTest < ActionController::TestCase
  setup do
    @companydescription = companydescriptions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:companydescriptions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create companydescription" do
    assert_difference('Companydescription.count') do
      post :create, companydescription: { content: @companydescription.content, isopen: @companydescription.isopen, startup_id: @companydescription.startup_id, title: @companydescription.title }
    end

    assert_redirected_to companydescription_path(assigns(:companydescription))
  end

  test "should show companydescription" do
    get :show, id: @companydescription
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @companydescription
    assert_response :success
  end

  test "should update companydescription" do
    put :update, id: @companydescription, companydescription: { content: @companydescription.content, isopen: @companydescription.isopen, startup_id: @companydescription.startup_id, title: @companydescription.title }
    assert_redirected_to companydescription_path(assigns(:companydescription))
  end

  test "should destroy companydescription" do
    assert_difference('Companydescription.count', -1) do
      delete :destroy, id: @companydescription
    end

    assert_redirected_to companydescriptions_path
  end
end
