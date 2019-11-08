class Match < ApplicationRecord
  # attributes
  # id                    int
  # created_at            DateTime
  # updated_at            DateTime
  # team_1_id             int
  # team_2_id             int
  # score_1               int
  # score_2               int
  # date                  DateTime
  # youtube_link          string
  # league_id             int

  belongs_to :league
end
