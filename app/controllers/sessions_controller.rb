class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id

      redirect_to projects_path, notice: "Logged in successfully."
    else

      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # 1. Borrar el user_id de la sesión
    session.delete(:user_id)

    redirect_to login_path, notice: "Logged out."
  end
end
