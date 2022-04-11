class Message < ApplicationRecord
  # Associations
  belongs_to :outbox
  belongs_to :inbox
end
