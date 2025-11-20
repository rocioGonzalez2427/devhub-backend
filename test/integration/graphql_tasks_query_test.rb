require "test_helper"

class GraphqlTasksQueryTest < ActionDispatch::IntegrationTest
  test "returns a list of tasks with basic fields" do
    project = Project.create!(
      name: "GraphQL Test Project",
      description: "Project for GraphQL tasks query test"
    )

    task = Task.create!(
      title: "GraphQL test task",
      description: "Task created from the GraphQL test",
      status: "pending",
      project: project
    )

    query = <<~GRAPHQL
      query {
        tasks {
          id
          title
          status
        }
      }
    GRAPHQL

    post "/graphql", params: { query: query }

    assert_response :success

    body = JSON.parse(@response.body)

    # Ensure "data" and "tasks" exist
    assert body["data"].key?("tasks"), "Expected 'data.tasks' key in GraphQL response"

    tasks_data = body["data"]["tasks"]

    # Ensure at least one task is returned
    assert tasks_data.any?, "Expected at least one task in the response"

    # Ensure the created task is present
    titles = tasks_data.map { |t| t["title"] }
    assert_includes titles, "GraphQL test task"
  end
end
