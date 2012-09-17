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
    collection = GameCollection.new(@username)
    if collection.count(:players => @players).nil? or collection.count(:players => @players) == 0
      return nil
    else
      @game = sample(collection)
    end
  end
  
  protected
  
  def sample(collection)
    games = collection.games(:players => @players.to_i)
    scores = games.collect do |game|
      score(collection, game)
    end
    scores = scores.collect do |score|
      score.to_f
    end
    
    #normalize ratings
    sum = scores.inject(:+)
    scores = scores.collect{|score| score/sum}
    
    #sample from games weighted by score
    target = rand()
    i = 0
    thresh=scores[i]
    while thresh < target do
      i = i+1
      thresh= thresh + scores[i]
    end
    games[i]
  end
  
  def score(collection, game)
    rating_score(collection, game) * suggested_players_score(game)
  end
  
  def rating_score(collection, game)
    collection.rating(game.id)
  end
  
  def suggested_players_score(game)
    case game.players_suggestion(@players.to_i)
    when "Best"
      2
    when "Recommended"
      1
    when "Not Recommended"
      0
    else
      0
    end
  end
end