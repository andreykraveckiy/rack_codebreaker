require './lib/racker'

use Rack::Session::Cookie, :key => 'rack.session'
use Rack::Static, root: 'public'
run Racker