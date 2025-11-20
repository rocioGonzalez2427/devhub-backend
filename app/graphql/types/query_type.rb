# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # Example field created by generator
    field :test_field, String, null: false,
          description: "An example field added by the generator"

    def test_field
      "Hello World!"
    end

    # Lists all tasks
    field :tasks, [Types::TaskType], null: false,
          description: "List all tasks in DevHub"

    def tasks
      Task.includes(:project, :assignee, :activities).order(created_at: :desc)
    end

    field :task, Types::TaskType, null: true do
      description "Find a single task by its ID"
      argument :id, ID, required: true
    end

    def task(id:)
      Task.includes(:project, :assignee, :activities).find_by(id: id)
    end

    field :projects, [Types::ProjectType], null: false,
          description: "List all projects in DevHub"

    def projects
      Project.includes(:tasks).order(created_at: :desc)
    end

    # list tasks assigned to the current user
    field :my_tasks, [Types::TaskType], null: false,
          description: "List tasks assigned to the currently logged-in user"

    def my_tasks
      user = context[:current_user]
      return Task.none unless user

      Task.assigned_to(user)
          .includes(:project, :assignee, :activities)
          .order(created_at: :desc)
    end

    # New: list activities for a given task
    field :activities, [Types::ActivityType], null: false do
      description "List all activity log entries for a given Task"
      argument :task_id, ID, required: true
    end

    def activities(task_id:)
      task = Task.find_by(id: task_id)
      return [] unless task

      task.activities.recent
    end

    #####################################
    # NEW QUERIES FROM PRD (fixed)
    #####################################

    field :project, Types::ProjectType, null: true do
      description "Find a project by its ID, including its tasks"
      argument :id, ID, required: true
    end

    def project(id:)
      Project.includes(:tasks).find_by(id: id)
    end

    field :user, Types::UserType, null: true do
      description "Get a user by ID, including tasks assigned to them"
      argument :id, ID, required: true
    end

    def user(id:)
      User.find_by(id: id)
    end

    field :all_users, [Types::UserType], null: false,
          description: "List all users in the system"

    def all_users
      User.order(:email)
    end

    #####################################
    # DEBUG: current logged-in user
    #####################################

    field :me, Types::UserType, null: true,
          description: "Currently logged-in user from GraphQL context"

    def me
      context[:current_user]
    end
  end
end
