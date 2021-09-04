module Exports
  class PlayerExportGenerator
    def initialize(players)
      @players = players
    end

    def build
      output = [header_row]
      @players.sort_by(&:last_name).each do |player|
        output << generate_player_row(player)
      end
      output.join("\n")
    end

    private

    def header_row
      ['Last Name', 'First Name', 'Position', 'Origin Country'].join(', ')
    end

    def generate_player_row(player)
      [
        player.last_name,
        player.first_name,
        player.position,
        player.origin_country
      ].join(', ')
    end
  end
end
