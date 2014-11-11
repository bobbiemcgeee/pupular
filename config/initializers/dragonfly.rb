require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  protect_from_dos_attacks true
  secret "cbc851c7d74c920abd9adbe49b987d367468bb105673012bb418d1124b17eb65"

  url_format "/media/:job/:name"

  datastore :s3,
   		bucket_name: 'pupular2',
   		access_key_id: ENV["AWS_ACCESS_KEY_ID"],
   		secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
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
