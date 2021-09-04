class PlayerExportsController < ApplicationController
  def index
    @player_exports = PlayerExport.all
    render json: @player_exports
  end
end