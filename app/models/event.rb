class Event < ApplicationRecord
  belongs_to :visitor

  scope :page_views, -> { where(event_type: "page_view") }
  scope :form_submits, -> { where(event_type: "form_submit") }

  validates :event_type, :path, :occurred_at, presence: true
end
