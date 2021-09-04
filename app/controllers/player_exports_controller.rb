class PlayerExportsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  
  def index
    @player_exports = PlayerExport.all
    render json: @player_exports
  end

  def create
    @player_export = PlayerExport.create(export_url: 'https://example.com')
    render json: @player_export
  end
end