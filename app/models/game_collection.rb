class GameCollection
  include HTTParty
  base_uri 'http://boardgamegeek.com'
  
  attr_accessor :data
  
  def initialize(username)
    @data = Rails.cache.read username
    if !@data
      options = {:query => {:username => username, :own => 1, :brief => 1, :stats => 1} }
      response = self.class.get("/xmlapi2/collection", options)
      @data = response.parsed_response
      Rails.cache.write(username, @data, :expires_in => 14400)
        
    end
    @data_map = {}
    self.items({}).each do |item|
      @data_map[item['objectid'].to_i] = item
    end
  end
  
  def count(args = {})
    self.items(args).count
  end
  
  def ids(args = {})
    begin
      items = self.items(args)
      items.collect do |item|
        item['objectid'].to_i
      end
    rescue NoMethodError => exception
      nil
    end
  end
  
  def games(args = {})
    games = []
    ids_to_retrieve = []
    
    #First retrieve as many games as possible from the cache
    self.ids(args).each do |id|
      game_data = Rails.cache.read id
      if game_data
        games << Game.new(game_data)
      else
        ids_to_retrieve << id
      end
    end
    
    # Build the rest of the games from a single request to BGG
    if ids_to_retrieve.length > 0
      options = { :query => { :id => ids_to_retrieve.join(',') } }
      response = self.class.get("/xmlapi2/thing", options)
      data = response.parsed_response
      items = self.items(args)
      items.each do |item|
        games << Game.new(item)
        Rails.cache.write(item['id'], item, :expires_in => 14400)
      end
    end
    games
  end
  
  def rating(id)
    @data_map[id]['stats']['rating']['value'] == 'N/A' ? @data_map[id]['stats']['rating']['average']['value'].to_i : @data_map[id]['stats']['rating']['value'].to_i
  end
  
  def items(args)
    begin
      items = data['items']['item']
      items = items.nil? ? [] : items
      items = items.class == Array ? items : [items]
      if args[:players]
        items = items.select do |item|
          (item['stats']['minplayers'].to_i <= args[:players].to_i) and (item['stats']['maxplayers'].to_i >= args[:players].to_i)
        end
      end
      return items
    rescue NoMethodError
      return []
    end
  end
end