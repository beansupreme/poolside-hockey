class PlayerExportsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  
  def index
    @player_exports = PlayerExport.all
    render json: @player_exports
  end

  def create
    PlayerExportJob.perform_later    
  end
end