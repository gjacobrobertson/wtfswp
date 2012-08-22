class PagesController < ApplicationController  
  
  def index
    @message = "WHAT THE FUCK SHOULD WE PLAY"
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
