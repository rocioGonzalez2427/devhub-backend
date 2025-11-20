# frozen_string_literal: true

module Types
  class TaskType < Types::BaseObject
    description "A task in DevHub"

    field :id, ID, null: false
    field :title, String, null: false
    field :description, String, null: true
    field :status, String, null: false

    field :project_id, Integer, null: false
    field :assignee_type, String, null: true
    field :assignee_id, Integer, null: true

    # Timestamps
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :project, Types::ProjectType, null: false
    field :assignee, Types::UserType, null: true
    field :activities, [Types::ActivityType], null: true

    def assignee
      return nil if object.assignee.nil?
      object.assignee
    end

    def activities
      object.activities.order(created_at: :desc)
    end
  end
end
