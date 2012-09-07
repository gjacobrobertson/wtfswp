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
    
end