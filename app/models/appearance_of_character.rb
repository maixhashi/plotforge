class AppearanceOfCharacter < ApplicationRecord
  belongs_to :character
  belongs_to :shuffled_overview
end
