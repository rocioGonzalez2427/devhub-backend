class User < ApplicationRecord
    # This adds methods to set and authenticate against a BCrypt password.
    # It expects a column named `password_digest` in the database.
    has_secure_password
    has_many :assigned_tasks, as: :assignee, class_name: "Task"

    validates :email, presence: true, uniqueness: true

    # --- Authorization helpers ---

    def admin?
        role == "admin"
    end
    
    def project_owner?(project)
        project.owner_id == id
    end
    
    def task_assignee?(task)
        task.assignee == self
    end
  
end