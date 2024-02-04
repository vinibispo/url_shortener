class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  retry_on ActiveRecord::Deadlocked

  around_perform do |job, block|
    capture_and_record_errors(job, block)
  end

  private

  def capture_and_record_errors(job, block)
    block.call
  rescue StandardError => e
    Rails.error.set_context(**error_context(job))
    Rails.error.report(e)
    raise e
  end

  def error_context(job)
    {
      active_job: job.class.name,
      job_id: job.job_id,
      arguments: job.arguments,
      queue: job.queue_name,
      scheduled_at: job.scheduled_at
    }
  end
end
