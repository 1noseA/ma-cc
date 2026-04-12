class Article < ApplicationRecord
  validates :title, presence: true
  validates :body,  presence: true

  scope :published, -> { where(published: true) }
end
