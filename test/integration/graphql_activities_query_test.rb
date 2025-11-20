require "test_helper"

class GraphqlActivitiesQueryTest < ActionDispatch::IntegrationTest
  test "returns activities for a given task" do
    # Arrange: create a project and a task
    project = Project.create!(
      name: "GraphQL Activities Project",
      description: "Project for GraphQL activities query test"
    )

    task = Task.create!(
      title: "Task with activities",
      description: "Task used to test activities(taskId:)",
      status: "pending",
      project: project
    )

    # Create some activities for this task
    Activity.create!(record: task, action: "created")
    Activity.create!(record: task, action: "status_changed")

    # GraphQL query: ask for activities(taskId: ...)
    query = <<~GRAPHQL
      query($taskId: ID!) {
        activities(taskId: $taskId) {
          id
          action
        }
      }
    GRAPHQL

    # Act: send POST request to /graphql
    post "/graphql",
         params: {
           query: query,
           variables: { taskId: task.id }.to_json
         },
         as: :json

    # Assert: response is successful
    assert_response :success

    body = JSON.parse(@response.body)

    # Ensure "data" and "activities" exist
    assert body.key?("data"), "Expected 'data' key in GraphQL response"
    assert body["data"].key?("activities"), "Expected 'data.activities' key in GraphQL response"

    activities_data = body["data"]["activities"]

    # Should have at least the two activities we created
    assert_equal 2, activities_data.size

    actions = activities_data.map { |a| a["action"] }
    assert_includes actions, "created"
    assert_includes actions, "status_changed"
  end
end
