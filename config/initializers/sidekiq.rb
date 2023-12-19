case Rails.env
when 'production'
  Rails.application.config.active_job.queue_adapter = :sidekiq
  require 'sidekiq/fetch'
  Sidekiq::BasicFetch::TIMEOUT = 15
end
