class UsersController < ApplicationController
  before_action :redirect_if_logged_in,   only: [:new, :create]
  before_action :redirect_if_logged_out,  only: [:show]

  def new
    @user = User.new(user_params)
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      byebug

      if params[:invite][:invite_type] && params[:invite][:invite_code]
        company_invite = CompanyInvite.find_by(invite_code: params[:invite][:invite_code])
        company = Company.find_by(id: company_invite.company_id)
        @user.companies << company

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
