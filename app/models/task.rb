class Task < ApplicationRecord
  belongs_to :project
  belongs_to :assignee, polymorphic: true, optional: true

  has_many :activities, as: :record, dependent: :destroy

  STATUSES = %w[pending in_progress done].freeze

  # Scopes
  scope :completed, -> { where(status: "done") }
  scope :recent, -> { order(created_at: :desc) }
  scope :assigned_to, -> (user) { where(assignee: user) }  

  # Callbacks
  after_create_commit :log_created_activity
  after_update_commit :log_updated_activity

  validates :title, presence: true
  validates :status, inclusion: { in: STATUSES }

  private

  def log_created_activity
    ActivityLoggerJob.perform_later(id, "created")
  end

  def log_updated_activity
    ActivityLoggerJob.perform_later(id, "updated")
  end
end
