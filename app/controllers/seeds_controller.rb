class SeedsController < ApplicationController
    # Protección contra CSRF no aplica para GET así que no hay problema
    def run
      begin
        load Rails.root.join("db/seeds.rb")
        render json: { status: "ok", message: "Seeds executed" }
      rescue => e
        render json: { status: "error", message: e.message }, status: 500
      end
    end
  end
  