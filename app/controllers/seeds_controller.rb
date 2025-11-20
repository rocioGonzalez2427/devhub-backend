# app/controllers/seeds_controller.rb
class SeedsController < ActionController::Base
    # We don't want any app-wide filters (like authenticate_user!)
    protect_from_forgery with: :null_session
  
    def run
      begin
        load Rails.root.join("db/seeds.rb")
        render json: { status: "ok", message: "Seeds executed" }
      rescue => e
        render json: { status: "error", message: e.message }, status: 500
      end
    end
  end
  