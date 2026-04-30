FactoryBot.define do
  factory :display_rule do
    association :form
    rule_type { "visit_count_gte" }
    threshold { 3 }
    enabled { true }
  end
end
