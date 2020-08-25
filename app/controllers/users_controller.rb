class UsersController < ApplicationController
  before_action :redirect_if_logged_in,   only: [:new, :create]
  before_action :redirect_if_logged_out,  only: [:show]

  def new
    @user = User.new(user_params)
  end

  def create
    @user = User.new(user_params)

    if params.dig(:invite, :invite_type) && params.dig(:invite, :invite_type) != "Company"
      flash[:error] = "The invite does not exist, user registration failed"
      redirect_to action: :new and return
    end  

    if params.dig(:invite, :invite_type) && params.dig(:invite, :invite_code)
      company_invite = Invite.find_by(invite_code: params[:invite][:invite_code])

      if company_invite.nil?
        flash[:error] = "The company invite does not exist, user registration failed"
        redirect_to action: :new and return
      elsif company_invite.used?
        flash[:error] = "The company invite has been used already, user registration failed"
        redirect_to action: :new and return
      end  
    end  

    if @user.save
      session[:user_id] = @user.id
          
      if company_invite.present?
        company = Company.find_by(id: company_invite.invitable_id)
        @user.companies << company
        company_invite.update(status: Invite.statuses[:used], user_id: @user.id)

        flash[:success] = "Welcome! You are now a member of #{company.name}"
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
