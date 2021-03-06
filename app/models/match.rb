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

  validates :match_date, presence: true
  validates :matchday, presence: true

  validates :team_1, uniqueness: { scope: [:team_2, :score_1, :score_2, :matchday, :match_date, :league], message: " // Match already exists." }

  has_one_attached :video_thumbnail
end
