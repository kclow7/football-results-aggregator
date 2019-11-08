class CreateMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :matches do |t|
      t.integer :team_1
      t.integer :team_2
      t.integer :score_1
      t.integer :score_2
      t.string :youtube_link
      t.datetime :match_date
      t.integer :league

      t.timestamps
    end
  end
end
