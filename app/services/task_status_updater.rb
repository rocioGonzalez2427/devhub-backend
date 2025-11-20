class TaskStatusUpdater
    def initialize(task, new_status)
      @task = task
      @new_status = new_status
    end
  
    def call
      @task.status = @new_status
  
      if @task.save
        ActivityLoggerJob.perform_later(@task.id, "status_changed")
        true
      else
        false
      end
    end
  end
  