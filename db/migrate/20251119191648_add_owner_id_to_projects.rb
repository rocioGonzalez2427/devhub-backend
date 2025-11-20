class AddOwnerIdToProjects < ActiveRecord::Migration[8.1]
  def change
    add_column :projects, :owner_id, :integer
    add_index :projects, :owner_id
  end
end
