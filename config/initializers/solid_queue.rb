case Rails.env
when 'production'
  # Use a real queuing backend for Active Job (and separate queues per environment).
  Rails.application.config.active_job.queue_adapter = :solid_queue
end
