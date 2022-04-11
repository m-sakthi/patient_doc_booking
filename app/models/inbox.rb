class Inbox < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :messages
end
