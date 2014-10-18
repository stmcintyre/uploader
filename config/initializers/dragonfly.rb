require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  protect_from_dos_attacks true
  secret "f286be56520798594df262f692b2c9c9691a2dcb8477df02a0054477a4a36e00"

  url_format "/media/:job/:name"

  if Rails.env.development? || Rails.env.test?
    datastore :file,
              root_path: Rails.root.join('public/system/dragonfly', Rails.env),
              server_root: Rails.root.join('public')
  else
    datastore :s3,
              bucket_name: 'uploader-stmcintyre',
              access_key_id: ENV['AWS_S3_KEY'],
              secret_access_key: ENV['AWS_S3_SECRET'],
              url_scheme: 'https'
  end
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
