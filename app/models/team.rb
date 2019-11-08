class Team < ApplicationRecord
  # attributes
  # id                    int
  # name                  string
  # created_at            DateTime
  # updated_at            DateTime
  # league_id             int

  belongs_to :league
end
