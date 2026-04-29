FactoryBot.define do
  factory :form_submission do
    association :form
    association :visitor
    email { "test@example.com" }
    name { "テスト 太郎" }
    submitted_at { Time.current }
  end
end
