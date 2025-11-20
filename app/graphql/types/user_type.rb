module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: false

    # New: expose user role
    field :role, String, null: false, description: "Role of the user (admin or member)"

    field :assigned_tasks, [Types::TaskType], null: false,
          description: "Tasks that are assigned to this user"

    def assigned_tasks
      object.assigned_tasks
    end
  end
end
