FactoryBot.define do
  factory :league do
    name { "Malaysian Super League" }
  end

  factory :match do
    score_1 { 1 }
    score_2 { 2 }
    match_date { DateTime.current }
  end

  factory :team do
    name { "Selangor FC" }
  end
end
