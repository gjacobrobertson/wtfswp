class PagesController < ApplicationController
  def index
  end
  
  def find
    @user = params[:user]
    @players = params[:players]
    render :layout => false
  end
  
end
