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
    when '/new_game' then new_game_path
    when '/scores' then scores_path
    when '/back' then back_path
    when '/hint' then hint_path
    when '/guess' then guess_path
    when '/restart' then restart_path
    when '/yes' then yes_path
    when '/no' then no_path
    when '/save' then save_path
    else
      Rack::Response.new('Not Found', 404)
    end
  end

  protected
    def new_game_path
      @game.listens_and_shows("new game")
      Rack::Response.new(render('index.html.erb'))
    end

    def scores_path
      @game.listens_and_shows("scores")
      Rack::Response.new(render('index.html.erb'))
    end

    def back_path
      @game.listens_and_shows("back")
      redirect_to_root
    end

    def hint_path
      @what_ask = "Hint"
      @game.listens_and_shows("hint")
      Rack::Response.new(render('index.html.erb'))
    end

    def guess_path
      @what_ask = @request.params['guess']
      @game.listens_and_shows(@what_ask) 
      Rack::Response.new(render('index.html.erb'))
    end

    def restart_path
      @game.listens_and_shows('restart')
      Rack::Response.new(render('index.html.erb'))
    end

    def yes_path
      @game.listens_and_shows('yes')
      Rack::Response.new(render('index.html.erb'))
    end

    def no_path
      @game.listens_and_shows('no')
      @request.session.clear
      redirect_to_root
    end

    def save_path     
      name =  @request.params['user_name']
      @game.listens_and_shows(name) unless name.empty?
      Rack::Response.new(render('index.html.erb'))
    end

    def render(template)
      @partial = '_' + @game.stage.to_s + '_stage.html.erb'
      path = File.expand_path("../views/#{template}", __FILE__)
      ERB.new(File.read(path)).result(binding)
    end

    def return_game
      @request.session["game"] ||= Codebreaker::GameProcess.new
    end

    def redirect_to_root
      Rack::Response.new do |response|
        response.redirect("/")
      end
    end
end