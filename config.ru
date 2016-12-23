require './lib/racker'
require './lib/login'

use Rack::Session::Cookie, :key => 'rack.session'
use Rack::Static, root: 'public'

run Racker