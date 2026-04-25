class Event < ApplicationRecord
  belongs_to :visitor

  validates :event_type, :path, :occurred_at, presence: true
end
