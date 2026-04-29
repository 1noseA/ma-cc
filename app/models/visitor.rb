class Visitor < ApplicationRecord
  has_many :events, dependent: :destroy
  has_many :form_submissions, dependent: :destroy
  has_one :lead, dependent: :destroy

  def page_view_count
    events.count { |e| e.event_type == "page_view" }
  end

  def recalculate_score!
    update!(score: ScoreCalculator.new(self).call)
  end

  validates :visitor_token, presence: true, uniqueness: true
  validates :first_visited_at, :last_visited_at, presence: true
end
