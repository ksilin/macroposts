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


end
