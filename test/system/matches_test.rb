require "application_system_test_case"

class MatchesTest < ApplicationSystemTestCase
  setup do
    @match = matches(:one)
  end

  test "visiting the index" do
    visit matches_url
    assert_selector "h1", text: "Matches"
  end

  test "creating a Match" do
    visit matches_url
    click_on "New Match"

    fill_in "League", with: @match.league
    fill_in "Match date", with: @match.match_date
    fill_in "Score 1", with: @match.score_1
    fill_in "Score 2", with: @match.score_2
    fill_in "Team 1", with: @match.team_1
    fill_in "Team 2", with: @match.team_2
    fill_in "Youtube link", with: @match.youtube_link
    click_on "Create Match"

    assert_text "Match was successfully created"
    click_on "Back"
  end

  test "updating a Match" do
    visit matches_url
    click_on "Edit", match: :first

    fill_in "League", with: @match.league
    fill_in "Match date", with: @match.match_date
    fill_in "Score 1", with: @match.score_1
    fill_in "Score 2", with: @match.score_2
    fill_in "Team 1", with: @match.team_1
    fill_in "Team 2", with: @match.team_2
    fill_in "Youtube link", with: @match.youtube_link
    click_on "Update Match"

    assert_text "Match was successfully updated"
    click_on "Back"
  end

  test "destroying a Match" do
    visit matches_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Match was successfully destroyed"
  end
end
