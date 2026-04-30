class Form < ApplicationRecord
  has_many :form_submissions, dependent: :destroy
  has_many :display_rules, dependent: :destroy

  validates :name, presence: true

  def should_display_for?(visitor)
    display_rules.any? { |rule| rule.matches?(visitor) }
  end
end
