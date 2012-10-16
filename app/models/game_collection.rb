class GameCollection
  include HTTParty
  base_uri 'http://boardgamegeek.com'

  attr_accessor :data

  def initialize(username)
    data = Rails.cache.read(username)
    if !data
      options = {:query => {:username => username, :own => 1, :brief => 1, :stats => 1} }
      response = self.class.get("/xmlapi2/collection", options)
      data = response.body
      Rails.cache.write(username, data, :expires_in => 14400)
    end
    @data = Nokogiri::XML(data)
  end

  def count(args = {})
    @data.xpath("//item").length
  end

  def ids(args = {})
    items = self.items(args)
    return items.xpath("@objectid").collect do |node|
      node.value.to_i
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
      data = Nokogiri::XML(response.body)
      items = data.xpath('/items/item')
      items.each do |item|
        games << Game.new(item.to_xml)
        puts "Caching ID: #{item.at_xpath('@id')}"
        Rails.cache.write(item.at_xpath('@id').value, item.to_xml, :expires_in => 14400)
      end
    end
    games
  end

  def rating(id)
    puts id
    user_rating = @data.at_xpath("items/item[@objectid = #{id}]/stats/rating/@value").value
    average_rating = @data.at_xpath("items/item[@objectid = #{id}]/stats/rating/average/@value").value
    return user_rating == 'N/A' ? average_rating.to_i : user_rating.to_i
  end

  def items(args)
    return @data.xpath("/items/item[stats/@minplayers <= #{args[:players]} and stats/@maxplayers >= #{args[:players]}]")
  end
end