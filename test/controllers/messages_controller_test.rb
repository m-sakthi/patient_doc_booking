require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  test "create messages" do
    assert_difference "Message.count", 1 do
      post "/messages", params: { message: { body: "Sample message." } }
    end

    assert_response :redirect

    message = Message.last
    assert_equal inboxes(:doctor).id, message.inbox_id
    assert_equal outboxes(:patient).id, message.outbox_id
    assert_not message.read
  end

  test "create messages with last message created one week ago" do
    Message.find(1).update(created_at: Time.now - 8.days)

    assert_difference "Message.count", 1 do
      post "/messages", params: { message: { body: "Sample message." } }
    end

    assert_response :redirect

    message = Message.last
    assert_equal inboxes(:admin).id, message.inbox_id
    assert_equal outboxes(:patient).id, message.outbox_id
    assert_not message.read
  end

  test "create a messages will increment inbox unread_count" do
    inbox = inboxes(:doctor)
    assert_equal inbox.unread_count, 1

    assert_difference "Message.count", 1 do
      post "/messages", params: { message: { body: "Sample message." } }
    end

    assert_response :redirect

    message = Message.last
    assert_equal inbox.id, message.inbox_id
    assert_equal outboxes(:patient).id, message.outbox_id
    assert_equal inbox.reload.unread_count, 2
  end

  test "marking a messages as read will decrement inbox unread_count" do
    inbox = inboxes(:doctor)
    patient_message = messages(:patient_message1)
    
    assert_equal inbox.unread_count, 1
    patch "/messages/#{patient_message.id}/mark_as_read"
    assert_response :redirect

    assert_equal inbox.id, patient_message.inbox_id
    assert_equal outboxes(:patient).id, patient_message.outbox_id
    assert_equal inbox.reload.unread_count, 0
  end

  test "triggering lost prescription should send message to admin" do
    inbox = inboxes(:admin)

    assert_equal inbox.unread_count, 0
    assert_difference "Message.count", 1 do
      assert_difference "Payment.count", 1 do
        post "/messages/lost_prescription"
      end
    end
    assert_response :redirect

    message = Message.last
    assert_equal inbox.id, message.inbox_id
    assert_equal outboxes(:patient).id, message.outbox_id
    assert_equal inbox.reload.unread_count, 1
  end
end