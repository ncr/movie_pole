module MoviesHelper

  def imdb_url(imdb_id)
    "http://www.imdb.com/title/tt#{imdb_id}/"
  end

end

