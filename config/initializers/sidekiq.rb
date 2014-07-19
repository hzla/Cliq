require 'sidekiq/web'

Sidekiq.configure_server do |config|
ActiveRecord::Base.configurations[Rails.env.to_s]['pool'] = 30
end

if Rails.env.production?
 Sidekiq.configure_server do |config|
 config.redis = { url: ENV["REDISTOGO_URL"]}
end
Sidekiq.configure_client do |config|
 config.redis = { url: ENV["REDISTOGO_URL"]}
end
end