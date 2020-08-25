Rails.application.routes.draw do

  resource :user, only: [:new, :create, :show]
  resource :session, only: [:new, :create, :destroy]
  root to: redirect("/user/new")

  get '/company_invite/:invite_code', to: "company_invites#show"
end
