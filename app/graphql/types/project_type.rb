# frozen_string_literal: true

module Types
  class ProjectType < Types::BaseObject
    description "A project in DevHub"

    # Basic Project fields
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String, null: true

    # Associated tasks for this project
    field :tasks, [Types::TaskType], null: true

    def tasks
      # Order tasks by most recent first
      object.tasks.order(created_at: :desc)
    end
  end
end
