# app/controllers/api/sessions_controller.rb
class Api::SessionsController < ApplicationController
    # React no usa authenticity_token
    skip_before_action :verify_authenticity_token
  
    # Permitimos login y logout sin pasar por require_login
    skip_before_action :require_login, only: [:create, :destroy]
  
    # POST /api/login
    def create
      user = User.find_by(email: params[:email])
  
      if user&.authenticate(params[:password])
        session[:user_id] = user.id
  
        render json: {
          success: true,
          user: {
            id: user.id,
            email: user.email,
            role: user.respond_to?(:role) ? user.role : nil
          }
        }
      else
        render json: {
          success: false,
          error: "Invalid email or password"
        }, status: :unauthorized
      end
    end
  
    # GET /api/current_user
    def current
      if current_user
        render json: {
          logged_in: true,
          user: {
            id: current_user.id,
            email: current_user.email,
            role: current_user.respond_to?(:role) ? current_user.role : nil
          }
        }
      else
        render json: { logged_in: false }, status: :unauthorized
      end
    end
  
    # DELETE /api/logout
    def destroy
      reset_session
      render json: { success: true }
    end
  end
  