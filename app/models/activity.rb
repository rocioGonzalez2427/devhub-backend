class Activity < ApplicationRecord
  # This is a polymorphic association.
  # It will allow Activity to belong to different models (Task, Project, etc.)
  belongs_to :record, polymorphic: true

  # Validations
  validates :action, presence: true

  # Scopes (helper queries)
  scope :recent, -> { order(created_at: :desc) }
  scope :for_tasks, -> { where(record_type: "Task") }
end
