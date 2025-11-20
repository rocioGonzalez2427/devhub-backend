class CreateActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :activities do |t|
      t.references :record, polymorphic: true, null: false
      t.string :action

      t.timestamps
    end
  end
end
