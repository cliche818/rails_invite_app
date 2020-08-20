module Controllers
  module AuthenticationHelpers

    def login_as(user)
      controller.session[:user_id] = user.id
    end

    def logout
      controller.session[:user_id] = nil
    end

  end
end
