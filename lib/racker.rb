require 'erb'
require 'codebreaker'

class Racker
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)    
    @request = Rack::Request.new(env)    
    @game = return_game
  end

  def response
    case @request.path
    when '/' then Rack::Response.new(render('index.html.erb'))
    when '/new_game' 
      @game.listens_and_shows("new game")
      Rack::Response.new(render('index.html.erb'))
    when '/scores' 
      @game.listens_and_shows("scores")
      Rack::Response.new(render('index.html.erb'))
    when '/back'
      @game.listens_and_shows("back")
      Rack::Response.new(render('index.html.erb'))
    when '/hint'
      @what_ask = "Hint"
      @game.listens_and_shows("hint")
      Rack::Response.new(render('index.html.erb'))
    when '/guess'
      @what_ask = @request.params['guess']
      @game.listens_and_shows(@what_ask) 
      Rack::Response.new(render('index.html.erb'))
    when '/restart'
      @what_ask = nil
      @game.listens_and_shows('restart')
      Rack::Response.new(render('index.html.erb'))
    when '/yes'
      @game.listens_and_shows('yes')
      Rack::Response.new(render('index.html.erb'))
    when '/no'
      @game.listens_and_shows('no')
      Rack::Response.new(render('index.html.erb'))
    when '/save'
      @game.listens_and_shows(@request.params['user_name'])
      Rack::Response.new(render('index.html.erb'))
    else 
      @request.session.clear
      Rack::Response.new('Not Found', 404)
    end
  end

  def render(template)
    @partial = '_' + @game.stage.to_s + '_stage.html.erb'
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def return_game
    @request.session["game"] ||= Codebreaker::GameProcess.new
  end
end