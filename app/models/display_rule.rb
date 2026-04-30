class DisplayRule < ApplicationRecord
  belongs_to :form

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
