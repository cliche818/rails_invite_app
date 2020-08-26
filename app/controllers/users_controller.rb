class UsersController < ApplicationController
  before_action :redirect_if_logged_in,   only: [:new, :create]
  before_action :redirect_if_logged_out,  only: [:show]

  def new
    @user = User.new(user_params)
  end

  def create
    @user = User.new(user_params)

    if params.dig(:invite, :invite_code)
      invite = Invite.find_by(invite_code: params[:invite][:invite_code])

      if invite.nil?
        flash[:error] = "The invite does not exist, user registration failed"
        redirect_to action: :new and return
      elsif invite.used?
        flash[:error] = "The invite has been used already, user registration failed"
        redirect_to action: :new and return
      end  
    end  

    if @user.save
      session[:user_id] = @user.id
          
      if invite.present?
        if invite.invitable_type == "Company"
          @user.companies << invite.invitable
        elsif invite.invitable_type == "Project"
          @user.projects << invite.invitable
        end
        invite.update(status: Invite.statuses[:used], user_id: @user.id)

        flash[:success] = "Welcome! You are now a member of #{invite.invitable.name}"
        redirect_to action: :show
      else
        flash[:success] = "Thank you for signing up"
        redirect_to action: :show
      end
    else
      flash[:error] = "Please complete all required info and try again"
      redirect_to action: :new
    end
  end

  def show
    @user = User.find(session[:user_id])
  end

private
  def user_params
    params.fetch(:user, {}).permit(:name, :email)
  end
end
