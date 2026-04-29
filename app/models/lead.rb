class Lead < ApplicationRecord
  belongs_to :visitor

  validates :email, presence: true
  validates :name, presence: true
  validates :first_converted_at, presence: true
  validates :visitor_id, uniqueness: true
end
