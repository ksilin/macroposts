class UsersController < ApplicationController
  def new
    @user = User.new
    @title = 'Sign Up'
  end

  #GET requests will use the show method per default
  # this route can be reached by using the helper methods user_path(@user) - it returns the partial url: /users/1
  # the helper user_url(@user)) returns the complete url: 127.0.0.1:3000/users/1

  # a link would look like:  <%=link_to user_path(@user), @user %>
  # the second @user in the context of a link_to is converted to user_path(@user) by rails
  # TODO : and the first one does not? try it
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def create
    # p params[:user]
    @user = User.new(params[:user])
    if @user.save
      redirect_to @user
      flash[:success] = "Welcome to the application"
    else
      @title = 'Sign Up'
      render :new
    end
  end

end
