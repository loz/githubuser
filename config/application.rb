require 'logger'
require 'erb'
require 'octokit'

$LOAD_PATH << File.expand_path('../../app', __FILE__)

def env
  @env ||= {}
end

def logger
  if env[:mode] == 'test'
    Logger.new(File.open(File.expand_path('../../log/test.log', __FILE__), 'a'))
  else
    Logger.new(STDOUT)
  end
end

env[:mode] = ENV["RACK_ENV"] || 'development'

require 'main_app'
require 'org_app'
