class Event < ApplicationRecord
  belongs_to :visitor

  validates :event_type, presence: true
end
