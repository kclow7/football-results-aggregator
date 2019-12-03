require 'rails_helper'
require 'pry'

RSpec.describe League do
  describe "validations" do
    context "when name is absent" do
      it "fails to save" do
        league = League.new()
        expect(league.save).to eq false
      end
    end

    it "should have many matches" do
      league = create(:league)
      team_1 = create(:team, league: league, name: "chelsea")
      team_2 = create(:team, league: league, name: "liverpool")
      matches = create_list(:match, 2, league: league, team_1: team_1, team_2: team_2)
      expect(league.matches).to eq matches
    end

    it "should have many teams" do
      binding.pry
      league = create(:league)
      team_1 = create(:team, league: league, name: "chelsea")
      team_2 = create(:team, league: league, name: "liverpool")
      expect(league.teams).to eq [team_1, team_2]
    end

    context "when you try to create a league with the same name as an existing league in the database" do
      it "the new league will not be valid" do
        league = create(:league, name: "ABC league")
        expect(League.new(name: "ABC league")).to_not be_valid
      end
    end
  end
end
