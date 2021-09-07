class PlayerExportJob < ApplicationJob
  queue_as :default

  def perform
    players = Player.all

    file_data = Exports::PlayerExportGenerator.new(players).build
    s3_url = CloudStorage::S3Manager.new.upload(file_data, filename)
    @player_export = PlayerExport.new(export_url: s3_url)
    @player_export.save
  end

  private

  def filename
    "player_exports_#{Time.zone.now.strftime('%Y%m%dT%H%M%S')}.csv"
  end
end