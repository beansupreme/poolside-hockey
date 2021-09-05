class PlayerExportsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  
  def index
    @player_exports = PlayerExport.all
    render json: @player_exports
  end

  def create
    players = Player.all

    file_data = Exports::PlayerExportGenerator.new(players).build
    s3_url = CloudStorage::S3Manager.new.upload(file_data, filename)
    @player_export = PlayerExport.new(export_url: s3_url)
    
    if @player_export.save
      render json: @player_export
    else
      render status: :unprocessable_entity, json: { errors: @player_export.errors.full_messages.join(', ')}
    end
  end

  private

  def filename
    "player_exports_#{Time.zone.now.strftime('%Y%m%dT%H%M%S')}.csv"
  end
end