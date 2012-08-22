module PagesHelper
  def welcome_message
    if @message.nil?
      @gamepicker.errors.each do |attr,msg|
        if attr == :username
          return "WHO THE FUCK ARE YOU?"
        elsif attr == :players
          return "HOW MANY OF YOU FUCKERS ARE THERE"
        end
      end
    else
      @message
    end
  end
end
