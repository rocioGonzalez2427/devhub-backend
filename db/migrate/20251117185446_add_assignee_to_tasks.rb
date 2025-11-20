class AddAssigneeToTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :tasks, :assignee_type, :string
    add_column :tasks, :assignee_id, :integer
  end
end
