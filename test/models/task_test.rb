require "test_helper"

class TaskTest < ActiveSupport::TestCase
  def setup
    # Minimal valid project for associations
    @project = Project.create!(
      name: "Test Project",
      description: "Project used in Task tests"
    )

    # Build a valid task (we don't need to save it yet for validation tests)
    @task = Task.new(
      title: "First task",
      description: "Sample task for tests",
      status: "pending",
      project: @project
    )
  end

  test "is valid with valid attributes" do
    assert @task.valid?
  end

  test "is invalid without a title" do
    @task.title = nil

    assert_not @task.valid?
    assert_includes @task.errors[:title], "can't be blank"
  end

  test "is invalid with an unsupported status" do
    @task.status = "invalid_status"

    assert_not @task.valid?
    assert_includes @task.errors[:status], "is not included in the list"
  end

  test "belongs to a project" do
    assert_equal @project, @task.project
  end
end
