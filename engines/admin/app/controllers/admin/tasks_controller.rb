# frozen_string_literal: true

module Admin
    class TasksController < ApplicationController
      layout "admin/application"
  
      # List all tasks in the system
      def index
        # Eager-load project and assignee to avoid N+1 queries
        @tasks = Task.includes(:project, :assignee).order(created_at: :desc)
      end
  
      # Show a single task
      def show
        @task = Task.includes(:project, :assignee, :activities).find(params[:id])
      end
    end
  end
  