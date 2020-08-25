class InvitesController < ApplicationController
  def show
    @invite = Invite.find_by(invite_code: params[:invite_code])
    @invitable = @invite.invitable
  end
end  