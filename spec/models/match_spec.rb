require 'rails_helper'

RSpec.describe Match do
  it "belongs to a league and 2 teams" do
    league = create(:league)
    team_1 = create(:team, league: league, name: "team 1")
    team_2 = create(:team, league: league, name: "team 2")
    match = create(:match, league: league, team_1: team_1, team_2: team_2)
    expect(match.team_1).to eq team_1
    expect(match.team_2).to eq team_2
    expect(match.league).to eq league
  end

  describe "validations" do
    context "When you try to create a match which is the same as an existing match" do
      it "the match will not persist in database" do
        league = create(:league, name: "Premier League")
        chelsea = create(:team, league: league, name: "Chelsea")
        arsenal = create(:team, league: league, name: "Arsenal")
        create(:match, league: league, team_1: chelsea, team_2: arsenal, score_1: 5, score_2: 0, matchday: 1, match_date: Date.new(2019,1,1))
        expect(Match.new(league: league, team_1: chelsea, team_2: arsenal, score_1: 5, score_2: 0, matchday: 1, match_date: Date.new(2019,1,1))).to_not be_valid
      end
    end
  end
end
