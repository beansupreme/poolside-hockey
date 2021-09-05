if Rails.application.credentials.dig(:aws, :access_key_id).present?
  Aws.config.update({
                      access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
                      secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key)
                    })
else
  Rails.logger.info "No AWS credentials found, stubbing aws interactions"
  Aws.config.update(stub_responses: true)
end
