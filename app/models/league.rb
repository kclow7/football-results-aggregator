class League < ApplicationRecord
  # attributes
  # id                    int
  # name                  string
  # created_at            DateTime
  # updated_at            DateTime

  has_many :teams
  has_many :matches

  validates :name, presence: true
end
