require 'rails_helper'

require "rspec/rails/shared_contexts/action_cable"
require "action_cable/testing/rspec/features"


describe 'visiting the home page', type: :feature, js: true, action_cable: :async do

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


    player_export_table = find(:table, 'Player Exports')

    expect(player_export_table).to have_table_row('File' => 'Download')
    new_export_count = PlayerExport.count
    expect(new_export_count).to eq(previous_export_count + 1)

    new_player_export = PlayerExport.order(:created_at).last
    expect(new_player_export.export_url).to not_be_nil
  end

  it 'shows an error if something goes wrong' do
    visit '/'

    # Stub a low level component to throw an error
    mock_s3_manager = instance_double(CloudStorage::S3Manager)
    allow(CloudStorage::S3Manager).to receive(:new).and_return(mock_s3_manager)
    allow(mock_s3_manager).to receive(:upload).and_raise(StandardError.new("S3 is not available right now"))
  
    click_on 'Create new export'

    expect(page).to have_content("We're sorry, something went wrong")
  end
end