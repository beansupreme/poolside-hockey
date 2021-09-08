require 'rails_helper'


describe 'visiting the home page', type: :feature, js: true do

  before do
    travel_to(Time.zone.parse('2021-09-05T14:01:32.000Z'))
    ActiveJob::Base.queue_adapter = :test
  end

  after do
    travel_back
  end

  let!(:player_henrik) do
    Player.create!(first_name: 'Henrik', last_name: 'Lundquist', position: 'Goalie', origin_country: 'Sweden' )
  end
  let!(:player_artemi) do
    Player.create!(first_name: 'Artemi', last_name: 'Panarin', position: 'Right Wing', origin_country: 'Russia' )
  end

  it 'allows the user to see players and make an export' do
    visit '/'

    previous_export_count = PlayerExport.count
    expect(previous_export_count).to eq(0)

    players_table = find(:table, 'Hockey Players')

    expect(players_table).to have_table_row('First Name' => 'Henrik', 'Last Name' => 'Lundquist', 'Position' => 'Goalie', 'Origin Country' => 'Sweden')
    expect(players_table).to have_table_row('First Name' => 'Artemi', 'Last Name' => 'Panarin', 'Position' => 'Right Wing', 'Origin Country' => 'Russia')
  
    click_on 'Create new export'

    sleep 5

    player_export_table = find(:table, 'Player Exports')

    expect(player_export_table).to have_table_row('File' => 'Download')
    new_export_count = PlayerExport.count
    expect(new_export_count).to eq(previous_export_count + 1)

    new_player_export = PlayerExport.order(:created_at).last
    expect(new_player_export.export_url).to not_be_nil
  end
end