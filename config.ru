require './lib/racker'

use Rack::Session::Cookie, :key => 'rack.session'
run Racker.new