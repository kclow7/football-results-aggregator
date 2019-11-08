class DeleteColumnsFromMatches < ActiveRecord::Migration[5.2]
  def change
    remove_columns :matches, :team_1, :team_2, :league
  end
end
