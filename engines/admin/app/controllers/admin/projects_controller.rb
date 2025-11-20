# frozen_string_literal: true

module Admin
    class ProjectsController < ApplicationController
      layout "admin/application"
  
      # List all projects in the system
      def index
        # Simple ordering, you can tweak this later
        @projects = Project.order(created_at: :desc)
      end
  
      # Show a single project (we'll keep it very basic for now)
      def show
        @project = Project.find(params[:id])
      end
    end
  end
  