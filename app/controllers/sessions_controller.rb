class SessionsController < ApplicationController

  def new
    @title = "Sign in"
  end

  #TODO : when to use redirect and when render?
  def create
    #using user without an @ - no view will need it, su cut back the scope
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user.nil?
      # with the user, we displayed error messages using the user model - a session is not a model, so we have to use flash
      flash.now[:error] = "Invalid email/password combination"
      @title = "Sign in"
      render :new
      # error message
    else
      sign_in user
      # either redirect the user to a page ha actually wanted to see, or
      # if none specified - redirect to profile
      redirect_back_or user
    end
  end

  def destroy
    sign_out
    redirect_to(root_path)
  end
end
