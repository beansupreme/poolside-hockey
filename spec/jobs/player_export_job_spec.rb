require 'rails_helper'

describe PlayerExportJob do
  describe '#perform' do
    let(:current_time) { Time.zone.parse('2021-09-05T14:01:32.000Z') }
    let(:mock_s3_manager) { instance_double(CloudStorage::S3Manager) }

    before do
      travel_to(current_time)
    end

    describe 'when successful' do
      it 'uploads a timestamped file to S3' do
        expected_file_name = 'player_exports_20210905T140132.csv'
        expect(CloudStorage::S3Manager).to receive(:new).and_return(mock_s3_manager)
        expect(mock_s3_manager).to receive(:upload).with(anything, expected_file_name).and_return('https://s3.url/file_upload.csv')
        
        PlayerExportJob.perform_now

        new_player_export = PlayerExport.order(:created_at).last

        expect(new_player_export.export_url).to eq('https://s3.url/file_upload.csv')
      end
  
      it 'sends a success message to ActionCable' do
        allow(CloudStorage::S3Manager).to receive(:new).and_return(mock_s3_manager)
        allow(mock_s3_manager).to receive(:upload).and_return('https://s3.url/file_upload.csv')

        expected_message = {
          "action": 'export_complete',
          "data": {
            "id": 1,
            "export_url": "https://s3.url/file_upload.csv",
            "created_at": "2021-09-05T14:01:32.000Z",
            "updated_at": "2021-09-05T14:01:32.000Z"
          }
        }

        expect {
          PlayerExportJob.perform_now
        }.to have_broadcasted_to("exports.1").with(expected_message)
      end
    end

    describe 'when there is an error' do
      it 'sends an error message to ActionCable' do
        allow(CloudStorage::S3Manager).to receive(:new).and_return(mock_s3_manager)
        allow(mock_s3_manager).to receive(:upload).and_raise(StandardError.new("S3 is not available right now"))

        expected_message = {
          "action" => 'error',
          "data" => "S3 is not available right now"
        }

        expect {
          PlayerExportJob.perform_now
        }.to have_broadcasted_to("exports.1").with(expected_message)
      end
    end
  end
end
