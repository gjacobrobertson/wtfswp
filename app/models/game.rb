class Game
  attr_accessor :data
  def initialize(data)
    @data = data
  end
  
  def id
    @data['id'].to_i
  end
  
  def title
    name = @data['name']
    name.class == Array ? name.find{|n| n['type'] == 'primary'}['value'] : name['value']
  end
  
  def players_suggestion(players)
    poll = @data['poll'].find do |p|
      p['name'] == 'suggested_numplayers'
    end
    results = poll['results'].find do |r|
      r['numplayers'] == players.to_s
    end
    result = results['result']
    suggestion = nil
    votes = 0
    result.each do |r|
      if r['numvotes'].to_i > votes
        votes = r['numvotes'].to_i
        suggestion = r['value']
      end
    end
    suggestion
  end
end