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
  belongs_to :team_1, class_name: "Team", foreign_key: "team_1_id"
  belongs_to :team_2, class_name: "Team", foreign_key: "team_2_id"

  validates :score_1, presence: true
  validates :score_2, presence: true
  validates :date, presence: true
end
