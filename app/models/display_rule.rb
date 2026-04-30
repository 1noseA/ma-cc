class DisplayRule < ApplicationRecord
  belongs_to :form

  validates :rule_type, presence: true
  validates :threshold, presence: true,
                        numericality: { only_integer: true, greater_than_or_equal_to: 0 },
                        if: -> { rule_type == "visit_count_gte" }

  def matches?(visitor)
    return false unless enabled

    case rule_type
    when "visit_count_gte"
      visitor.events.where(event_type: "page_view").count >= threshold
    else
      false
    end
  end
end
