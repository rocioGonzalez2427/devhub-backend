# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # Example field created by the generator
    field :test_field, String, null: false,
      description: "An example field added by the generator"

    def test_field
      "Hello World"
    end

    # Create a new project
    field :create_project, Types::ProjectType, null: false do
      description "Create a new project"
      argument :name, String, required: true
      argument :description, String, required: false
    end

    def create_project(name:, description: nil)
      project = Project.new(name: name, description: description)

      if project.save
        project
      else
        # In a real app we could return a custom error type or error list
        raise GraphQL::ExecutionError, project.errors.full_messages.join(", ")
      end
    end

    # Create a new task
    field :create_task, Types::TaskType, null: true do
      description "Create a new task in a project"
      argument :project_id, ID, required: true
      argument :title, String, required: true
      argument :description, String, required: false
      argument :status, String, required: false
    end

    def create_task(project_id:, title:, description: nil, status: "pending")
      user = context[:current_user]
      return nil unless user
    
      project = Project.find_by(id: project_id)
      return nil unless project
    
      # Only project owner or admin can create tasks in this project
      unless user.admin? || user.project_owner?(project)
        return nil
      end
    
      task = project.tasks.build(
        title: title,
        description: description,
        status: status,
        assignee: user # optional: default assignee is the creator
      )
    
      if task.save
        task
      else
        nil
      end
    end

    # Change the status of a task using TaskStatusUpdater
    field :change_task_status, Types::TaskType, null: true do
      description "Change the status of a task"
      argument :id, ID, required: true
      argument :status, String, required: true
    end

    def change_task_status(id:, status:)
      user = context[:current_user]
      return nil unless user
    
      task = Task.find_by(id: id)
      return nil unless task
    
      # Only the assignee of the task or an admin can change its status
      unless user.admin? || user.task_assignee?(task)
        return nil
      end
    
      service = TaskStatusUpdater.new(task, status)
    
      if service.call
        task
      else
        # If the service fails (e.g., invalid status), return nil
        nil
      end
    end  

    # Assign a task to a user
    field :assign_task, Types::TaskType, null: false do
      description "Assign a task to a user"
      argument :task_id, ID, required: true
      argument :assignee_id, ID, required: true
    end

    def assign_task(task_id:, assignee_id:)
      task = Task.find_by(id: task_id)
      user = User.find_by(id: assignee_id)

      # Validate that the task exists
      unless task
        raise GraphQL::ExecutionError, "Task not found with id=#{task_id}"
      end

      # Validate that the user exists
      unless user
        raise GraphQL::ExecutionError, "User not found with id=#{assignee_id}"
      end

      # Assign the task
      task.assignee = user

      if task.save
        task
      else
        raise GraphQL::ExecutionError, task.errors.full_messages.join(", ")
      end
    end

    # Update a task (title and description only)
    field :update_task, Types::TaskType, null: false do
      description "Update the title and/or description of a task"
      argument :id, ID, required: true
      argument :title, String, required: false
      argument :description, String, required: false
    end

    def update_task(id:, title: nil, description: nil)
      task = Task.find_by(id: id)

      # Validate the task exists
      unless task
        raise GraphQL::ExecutionError, "Task not found with id=#{id}"
      end

      # Update allowed attributes only
      update_data = {}
      update_data[:title] = title if title
      update_data[:description] = description if description

      if update_data.empty?
        raise GraphQL::ExecutionError, "No fields provided to update"
      end

      unless task.update(update_data)
        raise GraphQL::ExecutionError, task.errors.full_messages.join(", ")
      end

      task
    end
    
    #Delete task
    field :delete_task, Boolean, null: false do
      description "Delete a task by its ID"
      argument :id, ID, required: true
    end

    def delete_task(id:)
      user = context[:current_user]
      return false unless user&.admin?
    
      task = Task.find_by(id: id)
      return false unless task
    
      task.destroy
      true
    end    

    #Delete project
    field :delete_project, Boolean, null: false do
      description "Delete a project (and its tasks) by its ID"
      argument :id, ID, required: true
    end

    def delete_project(id:)
      user = context[:current_user]
      return false unless user&.admin?
    
      project = Project.find_by(id: id)
      return false unless project
    
      project.destroy
      true
    end    

    #Update Project
    field :update_project, Types::ProjectType, null: true do
      description "Update a project's attributes"
      argument :id, ID, required: true
      argument :name, String, required: false
      argument :description, String, required: false
    end

    def update_project(id:, name: nil, description: nil)
      user = context[:current_user]
      return nil unless user
    
      project = Project.find_by(id: id)
      return nil unless project
    
      # Only the owner of the project or an admin can update it
      unless user.admin? || user.project_owner?(project)
        # Not authorized
        return nil
      end
    
      project.update(
        name: name || project.name,
        description: description || project.description
      )
    
      project
    end    

    #Reasign Task
    field :reassign_task, Types::TaskType, null: true do
      description "Reassign a task to a different user"
      argument :task_id, ID, required: true
      argument :user_id, ID, required: true
    end

    def reassign_task(task_id:, user_id:)
      user = context[:current_user]
      return nil unless user&.admin?
    
      task = Task.find_by(id: task_id)
      new_assignee = User.find_by(id: user_id)
    
      return nil unless task && new_assignee
    
      task.update(assignee: new_assignee)
    
      # Optional: log activity
      ActivityLoggerJob.perform_later(task.id, "reassigned")
    
      task
    end    
  end
end
