require 'codebreaker'

class Racker
  def call(env)
    # [200, {'Content-Type' => 'text/plain'}, ['Something happens!']]
    # the same with another info
    @game = Codebreaker::GameProcess.new
    @game.listens_and_shows("new game")
    @game.listens_and_shows("hint")
    Rack::Response.new("We create the game #{@game.answers}")
  end
end

run Racker.new