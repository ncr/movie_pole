class HomeController < ApplicationController
  
  def show
    redirect_to(movies_path)
  end
  
end