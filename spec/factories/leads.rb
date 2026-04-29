FactoryBot.define do
  factory :lead do
    association :visitor
    email { "test@example.com" }
    name { "テスト 太郎" }
    first_converted_at { Time.current }
  end
end
