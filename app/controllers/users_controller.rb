class UsersController < ApplicationController

  # by default, the filters apply to every action, so we are restricting them
  before_filter :authenticate, :only => [:edit, :update, :index]
  before_filter :correct_user, :only => [:edit, :update]


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
      sign_in @user
      redirect_to @user
      flash[:success] = "Welcome to the application"
    else
      @title = 'Sign Up'
      # no need to worry about the errors - they are put inside the user model and can be retrieved in the view
      render :new
    end
  end

    # the @user will be prepared by the correct_user filter
  def edit
    @title = "Edit user"
  end

  # the @user will be prepared by the correct_user filter
  def update
    if @user.update_attributes(params[:user])
      #update user here
      redirect_to @user
      flash[:success] = "Changes were applied successfuly"
    else
      @title = "Edit user"
      render :edit
    end
  end

  def index
    @title = "All users"
    @users = User.all
  end

  private

  def authenticate
    deny_access unless signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

end
