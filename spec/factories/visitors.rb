FactoryBot.define do
  factory :visitor do
    visitor_token { "MyString" }
    first_visited_at { "2026-04-20 23:37:09" }
    last_visited_at { "2026-04-20 23:37:09" }
    score { 1 }
  end
end
