require 'test_helper'

class CompanyupdatesControllerTest < ActionController::TestCase
  setup do
    @companyupdate = companyupdates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:companyupdates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create companyupdate" do
    assert_difference('Companyupdate.count') do
      post :create, companyupdate: { content: @companyupdate.content, news_id: @companyupdate.news_id, newsdate: @companyupdate.newsdate, startup_id: @companyupdate.startup_id, title: @companyupdate.title }
    end

    assert_redirected_to companyupdate_path(assigns(:companyupdate))
  end

  test "should show companyupdate" do
    get :show, id: @companyupdate
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @companyupdate
    assert_response :success
  end

  test "should update companyupdate" do
    put :update, id: @companyupdate, companyupdate: { content: @companyupdate.content, news_id: @companyupdate.news_id, newsdate: @companyupdate.newsdate, startup_id: @companyupdate.startup_id, title: @companyupdate.title }
    assert_redirected_to companyupdate_path(assigns(:companyupdate))
  end

  test "should destroy companyupdate" do
    assert_difference('Companyupdate.count', -1) do
      delete :destroy, id: @companyupdate
    end

    assert_redirected_to companyupdate_index_path
  end
end
