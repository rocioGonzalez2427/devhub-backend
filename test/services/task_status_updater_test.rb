require "test_helper"

class TaskStatusUpdaterTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  def setup
    # Minimal valid project for the task
    @project = Project.create!(
      name: "Test Project",
      description: "Project used in TaskStatusUpdater tests"
    )

    # Start with a task in "pending" status
    @task = Task.create!(
      title: "Test task",
      description: "Task to test status updates",
      status: "pending",
      project: @project
    )
  end

  test "updates the task status and enqueues ActivityLoggerJob when status is valid" do
    new_status = "done"

    assert_enqueued_with(job: ActivityLoggerJob, args: [@task.id, "status_changed"]) do
      updater = TaskStatusUpdater.new(@task, new_status)
      result = updater.call

      # The service should return true
      assert result

      # The task should be updated in the database
      assert_equal new_status, @task.reload.status
    end
  end

  test "does not update the task status or enqueue job when status is invalid" do
    invalid_status = "invalid_status"

    assert_no_enqueued_jobs(only: ActivityLoggerJob) do
      updater = TaskStatusUpdater.new(@task, invalid_status)
      result = updater.call

      # The service should return false
      assert_not result

      # Status should NOT change in the database
      assert_not_equal invalid_status, @task.reload.status
    end
  end
end
