module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    #defining the current_user for use in all pages and ctrlrs
    # <%= current_user.name %>
    # redirect_to current_user

    # this is a method call
    current_user=(user)
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    # returns the current user if it's defined, or retrieves a user from token, then sets and remembers it
    @current_user ||= user_from_remember_token
  end

  def current_user?(user)
    user == current_user
  end


  def user_from_remember_token
    # the * operator - calling a method expecting two parameters with a two-element array instead
    User.authenticate_with_salt(*remember_token)
  end

  def remember_token
    # signed cookie support is not mature yet in rails, so we explicitly return an array of nils (p351)
    cookies.signed[:remember_token] || [nil, nil]
  end

  def sign_out
    cookies.delete(:remember_token)
    current_user= nil
  end

  def deny_access
    # storing the request target in the session for later redirect
    # (actually a cookie that persists as long as hte user has the browser window open)
    store_location
    # :notice is a shortcut to flash[:notice]
    # there is also an :error shortcut, but no :success shortcut
    redirect_to signin_path, :notice => "Please sign in to view this page"
  end


  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  # the privates
  private

  def store_location
    session[:return_to] = request.fullpath
  end

  def clear_return_to
    session[:return_to] = nil
  end


end
