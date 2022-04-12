class Message < ApplicationRecord
  # Associations
  belongs_to :outbox
  belongs_to :inbox

  after_create :increment_inbox_unread_count
  after_update :decrement_inbox_unread_count

  # Class methods
  def self.latest(user_id)
    Message.joins(inbox: :user).where(user: { id: user_id }).last
  end

  # Instance methods
  def is_in_past_week?
    created_at > Time.now - 1.week
  end

  def increment_inbox_unread_count
    self.inbox.update(unread_count: self.inbox.unread_count + 1)
  end

  def decrement_inbox_unread_count
    if saved_change_to_read? && self.read
      self.inbox.update(unread_count: self.inbox.unread_count - 1)
    end
  end
end
