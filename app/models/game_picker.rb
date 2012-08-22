require 'active_model'
class GamePicker
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :username, :players
  
  validates :username, :presence => true
  validates :players, :numericality => { :only_integer => true, :greater_than => 1 }
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
  
  def pick
    response = HTTParty.get("http://boardgamegeek.com/xmlapi/collection/#{@username}?own=1")
    data = response.parsed_response
    if data['items']['totalitems'] == '0'
      return nil
    else
      games = data['items']['item']
      valid_games = valid_games(games)
      @game = sample(valid_games)
    end
  end
  
  protected
  def valid_games(games)
    games.find_all{|game| (game['stats']['minplayers'].to_i <= @players.to_i) and (game['stats']['maxplayers'].to_i >= @players.to_i)}
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