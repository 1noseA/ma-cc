class Lead < ApplicationRecord
  belongs_to :visitor

  validates :email, presence: true
  validates :name, presence: true
end
