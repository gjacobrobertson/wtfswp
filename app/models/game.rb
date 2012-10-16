class Game
  attr_accessor :data
  def initialize(data)
    @data = Nokogiri::XML(data)
  end

  def id
    return @data.at_xpath('/item/@id').value.to_i
  end

  def title
    name = @data.at_xpath("/item/name[@type='primary']/@value").value
  end

  def players_suggestion(players)
    puts self.id
    results = @data.at_xpath("/item/poll[@name='suggested_numplayers']/results[@numplayers = #{players}]")
    if results.nil?
      return 'Recommended'
    end
    result = results.xpath('result')
    suggestion = nil
    votes = 0
    result.each do |r|
      if r.at_xpath('@numvotes').value.to_i > votes
        votes = r.at_xpath('@numvotes').value.to_i
        suggestion = r.at_xpath('@value').value
      end
    end
    suggestion
  end
end