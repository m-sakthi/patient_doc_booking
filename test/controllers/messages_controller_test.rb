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
end