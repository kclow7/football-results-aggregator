class AddLeagueToMatchesAndTeams < ActiveRecord::Migration[5.2]
  def change
    add_reference :matches, :league
    add_reference :teams, :league
  end
end
