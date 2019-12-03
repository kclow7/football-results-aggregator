require 'rails_helper'

RSpec.describe Team do
  describe "validations" do
    it "belongs to a league" do
      league = create(:league)
      team = create(:team, league: league)
      expect(team.league).to eq league
    end

    context "when you try to create a team with the same name as an existing team in the database" do
      it "the new team will not be valid" do
        league = create(:league)
        create(:team, league: league, name: "ABC fc")
        expect(Team.new(league: league, name: "ABC fc")).to_not be_valid
      end
    end
  end
end
