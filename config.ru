require './sinatra_app'
use Rack::MethodOverride
run MendelsPlaylistr::App.new