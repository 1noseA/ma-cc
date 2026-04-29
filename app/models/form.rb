class Form < ApplicationRecord
  has_many :form_submissions, dependent: :destroy

  validates :name, presence: true
end
