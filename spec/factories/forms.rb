FactoryBot.define do
  factory :form do
    name { "お問い合わせフォーム" }
    description { "気軽にお問い合わせください" }
    success_message { "送信ありがとうございました" }
  end
end
