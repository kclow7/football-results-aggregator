class AddMatchdayToMatches < ActiveRecord::Migration[5.2]
  def change
    add_column :matches, :matchday, :integer
  end
end
