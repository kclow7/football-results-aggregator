require 'rails_helper'

RSpec.describe Match do
  it "belongs to a league and 2 teams" do
    league = create(:league)
    team_1 = create(:team, league: league)
    team_2 = create(:team, league: league)
    match = create(:match, league: league, team_1: team_1, team_2: team_2)
    expect(match.team_1).to eq team_1
    expect(match.team_2).to eq team_2
    expect(match.league).to eq league
  end
end
