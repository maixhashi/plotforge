class Keyword < ApplicationRecord
  validates :content, presence: true, uniqueness: true
end