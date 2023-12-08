require "application_system_test_case"

class UserOrganizationsTest < ApplicationSystemTestCase
  setup do
    @user_organization = user_organizations(:one)
  end

  test "visiting the index" do
    visit user_organizations_url
    assert_selector "h1", text: "User organizations"
  end

  test "should create user organization" do
    visit user_organizations_url
    click_on "New user organization"

    fill_in "Organization", with: @user_organization.organization_id
    fill_in "User", with: @user_organization.user_id
    click_on "Create User organization"

    assert_text "User organization was successfully created"
    click_on "Back"
  end

  test "should update User organization" do
    visit user_organization_url(@user_organization)
    click_on "Edit this user organization", match: :first

    fill_in "Organization", with: @user_organization.organization_id
    fill_in "User", with: @user_organization.user_id
    click_on "Update User organization"

    assert_text "User organization was successfully updated"
    click_on "Back"
  end

  test "should destroy User organization" do
    visit user_organization_url(@user_organization)
    click_on "Destroy this user organization", match: :first

    assert_text "User organization was successfully destroyed"
  end
end
