class Visitor < ApplicationRecord
  validates :visitor_token, presence: true, uniqueness: true
  validates :first_visited_at, :last_visited_at, presence: true
end
