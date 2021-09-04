require 'rails_helper'

describe Exports::PlayerExportGenerator do
  describe '#build' do

    let!(:player_wayne) do
      Player.create!(first_name: 'Wayne', last_name: 'Gretzky', position: 'Centre', origin_country: 'Canada')
    end
    let!(:player_alex) do
      Player.create!(first_name: 'Alex', last_name: 'Ovechkin', position: 'Left Wing', origin_country: 'Russia')
    end
    let!(:player_teemu) do
      Player.create!(first_name: 'Teemu', last_name: 'Selanne', position: 'Left Wing', origin_country: 'Finland')
    end
    let(:players) { [player_wayne, player_alex, player_teemu] }


    subject { described_class.new(players) }


    it 'generates data with the expected format and content' do
      expected_content = <<~CSV
        Last Name, First Name, Position, Origin Country
        Gretzky, Wayne, Centre, Canada
        Ovechkin, Alex, Left Wing, Russia
        Selanne, Teemu, Left Wing, Finland
      CSV

      expect(subject.build).to eq(expected_content.chomp)
    end
  end
end