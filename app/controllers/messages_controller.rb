class MessagesController < ApplicationController

  def show
    @message = Message.find(params[:id])
  end

  def new
    @message = Message.new
  end

  def create
    current_user = User.current
    params_hash = message_params.merge(outbox_id: current_user.outbox.id)

    if User.current.is_patient
      if Message.latest(current_user.id).is_in_past_week?
        params_hash.merge!(inbox_id: User.doctor.first.inbox.id)
      else
        params_hash.merge!(inbox_id: User.admin.first.inbox.id)
      end
    end

    @message = Message.new(params_hash)
    if @message.valid?
      @message.save!
      redirect_to '/messages'
    else
      # More errors can be handled
      redirect_to '/422.html'
    end
  end

  private
  def message_params
    params.require(:message).permit(:body)
  end

end
