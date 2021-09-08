class PlayerExportJob < ApplicationJob
  queue_as :default

  def perform
    players = Player.all

    file_data = Exports::PlayerExportGenerator.new(players).build
    s3_url = CloudStorage::S3Manager.new.upload(file_data, filename)
    @player_export = PlayerExport.new(export_url: s3_url)
    @player_export.save
    
    broadcast_success_message
  rescue StandardError => error
    broadcast_error_message(error.message)
    Rails.logger.error(error)
  end

  private

  def filename
    "player_exports_#{Time.zone.now.strftime('%Y%m%dT%H%M%S')}.csv"
  end

  def player_export_data
    { 
      id: @player_export.id, 
      export_url: @player_export.export_url ,
      created_at: @player_export.created_at, 
      updated_at: @player_export.updated_at,
    }
  end
  
  def broadcast_success_message
    success_message = { action: "export_complete", data: player_export_data }
    ActionCable.server.broadcast("exports.#{current_user_id}", success_message) 
  end

  def broadcast_error_message(error)
    ActionCable.server.broadcast("exports.#{current_user_id}", { action: "error", data: error }) 
  end

  # hardcode user id since we don't have a login system in place yet
  def current_user_id
    1
  end
end