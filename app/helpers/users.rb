module Helpers::Users
  def current_user
    session[:user]
  end

  def require_user!
    redirect '/' unless current_user
  end
end
