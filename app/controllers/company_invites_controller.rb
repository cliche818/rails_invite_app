class CompanyInvitesController < ApplicationController
  def show
    @invite = CompanyInvite.find_by(invite_code: params[:invite_code])
    @company = @invite.company
  end
end  