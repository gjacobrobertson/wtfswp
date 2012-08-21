class PagesController < ApplicationController  
  
  def index
    @message = params[:message].nil? ? "WHAT THE FUCK SHOULD WE PLAY" : params[:message]
    @username = params[:username]
    @players = params[:players] == 0 ? nil : params[:players]
    puts @players
  end

  def find
    @username = params[:username]
    @players = params[:players]
    if @username == ''
      redirect_to :action => "index", :message => "ENTER YOUR FUCKING NAME", :players => @players
    elsif @players == ''
      redirect_to :action => "index", :message => "HOW MANY OF YOU FUCKERS ARE THERE", :username => @username
    else
      @players = @players.to_i
      response = HTTParty.get("http://boardgamegeek.com/xmlapi/collection/#{@username}?own=1")
      data = response.parsed_response
      if data['items']['totalitems'] == '0'
        redirect_to :action => "index", :message => "STOP FUCKING AROUND. ENTER A REAL USERNAME", :players => @players
      else
        games = data['items']['item']
        valid_games = valid_games(games)
        @game = sample(valid_games)
      end
    end
  end
  
  protected
  def valid_games(games)
    games.find_all{|game| (game['stats']['minplayers'].to_i <= @players) and (game['stats']['maxplayers'].to_i >= @players)}
  end
  
  def sample(games)
    ratings = games.collect{|game| game['stats']['rating']['value'] != 'N/A' ? game['stats']['rating']['value'] : game['stats']['rating']['average']['value']}
    ratings = ratings.collect{|rating| rating.to_f}
    
    #normalize ratings
    sum = ratings.inject(:+)
    ratings = ratings.collect{|rating| rating/sum}
    
    #sample from games weighted by rating
    target = rand()
    i = 0
    thresh=ratings[i]
    while thresh < target do
      i = i+1
      thresh= thresh + ratings[i]
    end
    games[i]
  end
end
