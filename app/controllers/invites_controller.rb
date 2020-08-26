class InvitesController < ApplicationController
  def show
    @invite = Invite.find_by(invite_code: params[:invite_code])
    @invitable = @invite.invitable
  end

  def join_invite
    user = User.find_by(id: session[:user_id])

    invite = Invite.find_by(invite_code: params[:invite][:invite_code])

    if invite.invitable_type == "Company"
      # if @user.companies.exists?(invite.invitable_id)
      #   flash[:error] = "You are already a member of #{invite.invitable.name}"
      #   redirect_to user_path and return
      # else
        user.companies << invite.invitable
      # end
    elsif invite.invitable_type == "Project"
    #   if @user.projects.exists?(invite.invitable_id)
    #     flash[:error] = "You are already a member of #{invite.invitable.name}"
    #     redirect_to user_path and return
    #   else
        user.projects << invite.invitable
    #   end
    end

    invite.update(status: Invite.statuses[:used], user_id: user.id)
    flash[:success] = "You are now a member of #{invite.invitable.name}"
    redirect_to user_path
  end
end  