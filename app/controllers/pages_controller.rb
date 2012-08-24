class PagesController < ApplicationController  
  
  def index
    @message = "WHAT THE <span class='fuck'>FUCK</span> SHOULD WE PLAY".html_safe
    @gamepicker = GamePicker.new()
  end

  def find
    @gamepicker = GamePicker.new(:username => params[:username], :players => params[:players])
    if @gamepicker.valid?
      @game = @gamepicker.pick
    else
      render :index
    end
  end
end
