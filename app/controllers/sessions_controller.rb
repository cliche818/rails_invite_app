class SessionsController < ApplicationController
  before_action :redirect_if_logged_in,   only: [:new, :create]
  before_action :redirect_if_logged_out,  only: [:destroy]

  def new
  end

  def create
    @user = User.find_by(email: session_params[:email])

    if params.dig(:invite, :invite_code)
      invite = Invite.find_by(invite_code: params[:invite][:invite_code])

      if invite.nil?
        flash[:error] = "Failed to log in because of invalid invite, please try again"
        redirect_to action: :new and return
      elsif invite.used?
        flash[:error] = "Failed to log in because invite has been used already, please try again"
        redirect_to action: :new and return
      end
    end

    if @user
      session[:user_id] = @user.id

      if invite.present?
        if invite.invitable_type == "Company"
          if @user.companies.exists?(invite.invitable_id)
            flash[:error] = "You are already a member of #{invite.invitable.name}"
            redirect_to user_path and return
          else
            @user.companies << invite.invitable
          end
        elsif invite.invitable_type == "Project"
          if @user.projects.exists?(invite.invitable_id)
            flash[:error] = "You are already a member of #{invite.invitable.name}"
            redirect_to user_path and return
          else
            @user.projects << invite.invitable
          end
        end

        invite.update(status: Invite.statuses[:used], user_id: @user.id)

        flash[:success] = "You are now a member of #{invite.invitable.name}"
        redirect_to user_path
      else
        flash[:success] = "You are logged in"
        redirect_to user_path
      end
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
