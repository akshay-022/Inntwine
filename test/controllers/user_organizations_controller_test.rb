require "test_helper"

class UserOrganizationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_organization = user_organizations(:one)
  end

  test "should get index" do
    get user_organizations_url
    assert_response :success
  end

  test "should get new" do
    get new_user_organization_url
    assert_response :success
  end

  test "should create user_organization" do
    assert_difference("UserOrganization.count") do
      post user_organizations_url, params: { user_organization: { organization_id: @user_organization.organization_id, user_id: @user_organization.user_id } }
    end

    assert_redirected_to user_organization_url(UserOrganization.last)
  end

  test "should show user_organization" do
    get user_organization_url(@user_organization)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_organization_url(@user_organization)
    assert_response :success
  end

  test "should update user_organization" do
    patch user_organization_url(@user_organization), params: { user_organization: { organization_id: @user_organization.organization_id, user_id: @user_organization.user_id } }
    assert_redirected_to user_organization_url(@user_organization)
  end

  test "should destroy user_organization" do
    assert_difference("UserOrganization.count", -1) do
      delete user_organization_url(@user_organization)
    end

    assert_redirected_to user_organizations_url
  end
end
