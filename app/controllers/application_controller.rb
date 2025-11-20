class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user, :logged_in?

  before_action :require_login

  def current_user
    # Memoriza el usuario, solo lo busca una vez
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    return if logged_in?

    # 👇 Para GraphQL y APIs: regresamos JSON 401 en vez de redirect HTML
    if request.path == "/graphql" || request.format.json?
      render json: { errors: [{ message: "Unauthorized" }] }, status: :unauthorized
    else
      # 👇 Para vistas normales HTML
      redirect_to login_path, alert: "Please log in to continue."
    end
  end
end
