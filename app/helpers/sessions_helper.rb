module SessionsHelper
  # logs in given user
  def log_in(user)
    session[:user_id] = user.id
  end
  
  #returns the current logged in user, if any
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  # returns true if the user is logged in, false if its not
  def logged_in?
    !current_user.nil?
  end
  
  # Logs out the current user.
  def log_out
    reset_session
    @current_user = nil
  end
end
