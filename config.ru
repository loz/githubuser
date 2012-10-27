require 'config/application'
map '/' do
  run MainApp
end

map '/org' do
  run OrgApp
end
