FactoryBot.define do
  factory :event do
    association :visitor
    event_type { "page_view" }
    path { "/articles/1" }
    occurred_at { Time.current }
  end
end
