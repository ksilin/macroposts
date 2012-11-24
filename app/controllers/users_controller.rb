class UsersController < ApplicationController
  def new
    @title = 'Sign Up'
  end

  #GET requests will use the show method per default
  def show
  @user = User.find(params[:id])
  end

end
