module SessionsHelper
  # logs in given user
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # Remembers a user in a persistent session
  def remember(user)
    user.remember
    # This creates a permanent, encrypted cookie on the browser with the user id
    cookies.permanent.signed[:user_id] = user.id
    # This creates a permanent cookie of the remember token
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  def current_user?(user)
    user && user == current_user
  end
  
  #returns the current logged in user, if any
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # returns true if the user is logged in, false if its not
  def logged_in?
    !current_user.nil?
  end
  
  # forgets a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # Logs out the current user.
  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end
  
  # redirects to stored location (or the default available)
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  
  # stores the URL trying to be accessed for friendly forwarding
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
