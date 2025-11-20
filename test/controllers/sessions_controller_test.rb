require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(
      email: "login_test@example.com",
      password: "password123"
    )
  end

  test "login succeeds with correct credentials" do
    post login_path, params: {
      email: @user.email,
      password: "password123"
    }

    # The controller redirects somewhere after successful login
    assert_response :redirect

    # Session should now contain the user's id
    assert_equal @user.id, session[:user_id]
  end

  test "login fails with wrong password" do
    post login_path, params: {
      email: @user.email,
      password: "wrongpassword"
    }

    # Should render the login form again (200 OK)
    assert_response :unprocessable_entity

    # Session should NOT have a user_id
    assert_nil session[:user_id]
  end

  test "logout clears the session" do
    # First log in
    post login_path, params: {
      email: @user.email,
      password: "password123"
    }

    assert_equal @user.id, session[:user_id]

    # Now log out
    delete logout_path

    # Session should be cleared
    assert_nil session[:user_id]

    # Logout usually redirects
    assert_response :redirect
  end
end
