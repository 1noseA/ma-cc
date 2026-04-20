FactoryBot.define do
  factory :visitor do
    sequence(:visitor_token) { |n| "token_#{n}" }
    first_visited_at { "2026-04-20 23:37:09" }
    last_visited_at { "2026-04-20 23:37:09" }
    score { 1 }
  end
end
