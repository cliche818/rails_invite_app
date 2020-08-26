Rails.application.routes.draw do

  resource :user, only: [:new, :create, :show]
  resource :session, only: [:new, :create, :destroy]
  root to: redirect("/user/new")

  get '/invite/:invite_code', to: "invites#show"
  post '/join_invite', to: "invites#join_invite"
end
