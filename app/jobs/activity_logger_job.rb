class ActivityLoggerJob < ApplicationJob
  queue_as :default

  def perform(task_id, event)
    task = Task.find_by(id: task_id)
    return unless task

    # Create an Activity record associated to the task
    Activity.create!(
      record: task,
      action: event
    )

    # Optional: keep logging to the Rails log for debugging
    Rails.logger.info "[ActivityLoggerJob] Activity created for Task ##{task.id} - Event: #{event}"
  end
end
