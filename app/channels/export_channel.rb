class ExportChannel < ApplicationCable::Channel
  def subscribed
    stream_from "exports.#{current_user_id}"
  end
  
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
  
  private
  
  # TODO: Make each websocket connection specific to a user session
  # hardcode user id since we don't have a login system in place yet
  def current_user_id
    1
  end
end
