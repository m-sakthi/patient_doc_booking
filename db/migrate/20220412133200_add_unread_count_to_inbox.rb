class AddUnreadCountToInbox < ActiveRecord::Migration[7.0]
  def change
    add_column :inboxes, :unread_count, :integer, default: 0
  end
end
