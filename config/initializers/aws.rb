if Rails.env.test?
  Aws.config.update(stub_responses: true)
else
  Aws.config.update({
                      access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
                      secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key)
                    })
end
