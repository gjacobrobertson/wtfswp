module PagesHelper
  def welcome_message
    @gamepicker.errors.each do |attr,msg|
      return msg
    end
    return "WHAT THE <span class='fuck'>FUCK</span> SHOULD WE PLAY".html_safe
  end
end
