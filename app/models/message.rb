class Message < ApplicationRecord
  # Associations
  belongs_to :outbox
  belongs_to :inbox

  # Class methods
  def self.latest(user_id)
    Message.joins(inbox: :user).where(user: { id: user_id }).last
  end

  # Instance methods
  def is_in_past_week?
    created_at > Time.now - 1.week
  end
end
