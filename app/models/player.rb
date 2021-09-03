class Player < ApplicationRecord
  POSITIONS = [
    LEFT_WING_POSITION = 'Left Wing'.freeze,
    CENTRE_WING_POSITION = 'Centre'.freeze,
    RIGHT_WING_POSITION = 'Right Wing'.freeze,
    DEFENSEMAN_POSTITION = 'Defenseman'.freeze,
    GOALIE_POSITION = 'Goalie'.freeze,
  ].freeze

end