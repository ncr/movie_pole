class MoviesController < ApplicationController
  
  def index
    @movies = Movie.most_voted.best_rated
  end

  def show
    @movie = Movie.find(params[:id])
  end
  
end