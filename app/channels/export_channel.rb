class ExportChannel < ApplicationCable::Channel
  def subscribed
    # hardcode user id since we don't have a login system in place yet
    user_id = 1
    stream_from "exports.#{user_id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
