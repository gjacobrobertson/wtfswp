module PagesHelper
  def welcome_message
    @gamepicker.errors.each do |attr,msg|
      puts msg
      return t(msg)
    end
    return t(:welcome_message).html_safe
  end

  def game_link(game)
    game ? link_to(emphasize(game.title), "http://boardgamegeek.com/boardgame/#{game.id}") : t(:nothing)
  end

  private

  def emphasize(text)
    I18n.locale.to_s == 'en' ? text.upcase : text
  end
end