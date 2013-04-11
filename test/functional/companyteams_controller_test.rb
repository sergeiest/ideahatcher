require 'test_helper'

class CompanyteamsControllerTest < ActionController::TestCase
  setup do
    @companyteam = companyteams(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:companyteams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create companyteam" do
    assert_difference('Companyteam.count') do
      post :create, companyteam: { address: @companyteam.address, cmuaffiliation: @companyteam.cmuaffiliation, description: @companyteam.description, email: @companyteam.email, firstname: @companyteam.firstname, lastname: @companyteam.lastname, linkedin: @companyteam.linkedin, phone: @companyteam.phone, picture_id: @companyteam.picture_id, startup_id: @companyteam.startup_id, title: @companyteam.title }
    end

    assert_redirected_to companyteam_path(assigns(:companyteam))
  end

  test "should show companyteam" do
    get :show, id: @companyteam
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @companyteam
    assert_response :success
  end

  test "should update companyteam" do
    put :update, id: @companyteam, companyteam: { address: @companyteam.address, cmuaffiliation: @companyteam.cmuaffiliation, description: @companyteam.description, email: @companyteam.email, firstname: @companyteam.firstname, lastname: @companyteam.lastname, linkedin: @companyteam.linkedin, phone: @companyteam.phone, picture_id: @companyteam.picture_id, startup_id: @companyteam.startup_id, title: @companyteam.title }
    assert_redirected_to companyteam_path(assigns(:companyteam))
  end

  test "should destroy companyteam" do
    assert_difference('Companyteam.count', -1) do
      delete :destroy, id: @companyteam
    end

    assert_redirected_to companyteams_path
  end
end
