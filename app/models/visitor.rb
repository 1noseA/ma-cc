class Visitor < ApplicationRecord
  validates :visitor_token, presence: true, uniqueness: true
end
