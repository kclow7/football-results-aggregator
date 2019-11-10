require 'rails_helper'

RSpec.describe League do
  context "when name is absent" do
    it "fails to save" do
      league = League.new()
      expect(league.save).to eq false
    end
  end

  it "should have many matches" do
    league = create(:league)
    team_1 = create(:team, league: league)
    team_2 = create(:team, league: league)
    matches = create_list(:match, 2, league: league, team_1: team_1, team_2: team_2)
    expect(league.matches).to eq matches
  end

  it "should have many teams" do
    league = create(:league)
    teams = create_list(:team, 2, league: league)
    expect(league.teams).to eq teams
  end
end
