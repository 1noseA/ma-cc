class FormSubmission < ApplicationRecord
  belongs_to :form
  belongs_to :visitor

  validates :email, presence: true
  validates :name, presence: true
end
