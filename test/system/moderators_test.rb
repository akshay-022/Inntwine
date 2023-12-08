require "application_system_test_case"

class ModeratorsTest < ApplicationSystemTestCase
  setup do
    @moderator = moderators(:one)
  end

  test "visiting the index" do
    visit moderators_url
    assert_selector "h1", text: "Moderators"
  end

  test "should create moderator" do
    visit moderators_url
    click_on "New moderator"

    fill_in "Community", with: @moderator.community_id
    fill_in "User", with: @moderator.user_id
    click_on "Create Moderator"

    assert_text "Moderator was successfully created"
    click_on "Back"
  end

  test "should update Moderator" do
    visit moderator_url(@moderator)
    click_on "Edit this moderator", match: :first

    fill_in "Community", with: @moderator.community_id
    fill_in "User", with: @moderator.user_id
    click_on "Update Moderator"

    assert_text "Moderator was successfully updated"
    click_on "Back"
  end

  test "should destroy Moderator" do
    visit moderator_url(@moderator)
    click_on "Destroy this moderator", match: :first

    assert_text "Moderator was successfully destroyed"
  end
end
