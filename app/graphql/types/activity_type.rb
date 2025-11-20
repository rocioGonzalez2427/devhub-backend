# frozen_string_literal: true

module Types
  class ActivityType < Types::BaseObject
    description "An activity log entry for a record (e.g., a Task)"

    # Según tu modelo Activity: id, record_type, record_id, action, created_at
    field :id, ID, null: false
    field :record_type, String, null: false
    field :record_id, Integer, null: false
    field :action, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
