class SessionsController < ApplicationController
  before_action :redirect_if_logged_in,   only: [:new, :create]
  before_action :redirect_if_logged_out,  only: [:destroy]

  def new
  end

  def create
    @user = User.find_by(email: session_params[:email])

    if @user
      session[:user_id] = @user.id
      flash[:success] = "You are logged in"
      redirect_to user_path
    else
      flash[:error] = "Failed to log in, please try again"
      redirect_to action: :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You are now logged out"
    redirect_to new_session_path
  end

  private
  def session_params
    params.fetch(:session, {}).permit(:email)
  end
end
