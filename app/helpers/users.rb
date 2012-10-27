module Helpers::Users
  def current_user
    session[:user]
  end

  def require_user!
    redirect '/' unless current_user
  end

  def client
    client_class.new :oauth_token => current_user[:token]
  end
end
