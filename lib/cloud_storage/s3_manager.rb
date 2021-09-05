module CloudStorage
  class S3Manager
    def initialize
      resource = Aws::S3::Resource.new(region: Rails.application.credentials.dig(:aws, :region))
      @bucket = resource.bucket(Rails.application.credentials.dig(:aws, :bucket))
    end

    def upload(data, file_name)
      object = @bucket.object(file_name)
      object.put(
        {
          content_type: 'application/octet-stream',
          acl: 'public-read',
          body: data
        }
      )
      object.public_url
    end
  end
end