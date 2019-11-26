class Match < ApplicationRecord
  # attributes
  # id                    int
  # created_at            DateTime
  # updated_at            DateTime
  # team_1_id             int
  # team_2_id             int
  # score_1               int
  # score_2               int
  # match_date            DateTime
  # youtube_link          string
  # league_id             int
  # matchday              int
  # video_title           string

  belongs_to :league
  belongs_to :team_1, class_name: "Team", foreign_key: "team_1_id"
  belongs_to :team_2, class_name: "Team", foreign_key: "team_2_id"

  validates :score_1, presence: true
  validates :score_2, presence: true
  validates :match_date, presence: true
  validates :matchday, presence: true

  has_one_attached :video_thumbnail
end
