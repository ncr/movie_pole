class MoviesController < ApplicationController
  
  def index
    @movies = Movie.all
  end

  def show
    @movie = Movie.find(params[:id])
  end


  def fetch
    count = Movie.fetch_from_this_month
    if count == 0
      flash[:notice] = "Nothing new, sorry!"
    else
      flash[:notice] = "I've got #{count} movies!"
    end
    redirect_to movies_path
  end
  
end