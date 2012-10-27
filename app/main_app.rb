require 'sinatra'
require 'omniauth'
require 'omniauth-github'
require 'helpers'

class MainApp < Sinatra::Application
  use Rack::Session::Cookie
  use OmniAuth::Builder do
    provider :github, ENV['GH_TOKEN'], ENV['GH_SECRET']
  end

  helpers Helpers::Users

  get '/' do
    erb :index
  end

  get '/auth/github/callback' do
    auth = env['omniauth.auth']
    user = {
      :name => auth.info.nickname,
      :uid => auth.uid.to_s,
      :token => auth.credentials.token
    }
    session[:user] = user
    redirect '/'
  end
end
