require 'sinatra'
require 'helpers'

class OrgApp < Sinatra::Application

  attr_reader :client_class

  def initialize(*args)
    super
    options = args.last
    options = {} unless options.is_a? Hash
    @client_class = options[:client_class] || Octokit::Client
  end

  use Rack::Session::Cookie
  helpers Helpers::Users

  before { require_user! }

  get "/:orgid/" do |name|
    @org = client.organization(name)
    erb :"org/index"
  end
end
