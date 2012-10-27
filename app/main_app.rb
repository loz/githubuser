require 'sinatra'
require 'omniauth'
require 'omniauth-github'
require 'helpers'

class MainApp < Sinatra::Application

  attr_reader :client_class

  def initialize(*args)
    super
    options = args.last
    options = {} unless options.is_a? Hash
    @client_class = options[:client_class] || Octokit::Client
  end

  use Rack::Session::Cookie
  use OmniAuth::Builder do
    provider :github, ENV['GH_TOKEN'], ENV['GH_SECRET'], scope: "user,repo"
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
