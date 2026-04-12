FactoryBot.define do
  factory :article do
    sequence(:title) { |n| "サンプル記事 #{n}" }
    body      { "これはテスト記事の本文です。" }
    published { true }
  end
end
