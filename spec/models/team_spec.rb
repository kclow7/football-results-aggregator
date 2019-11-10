require 'rails_helper'

RSpec.describe Team do
  it "belongs to a league" do
    league = create(:league)
    team = create(:team, league: league)
    expect(team.league).to eq league
  end
end
