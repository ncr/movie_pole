require "open-uri"
require "hpricot"

require "lib/power_search"
require "lib/now_playing"

module IMDB
  BASE_URI = "http://www.imdb.com"
  HEADERS = { "User-Agent" => "IMRb/0.0" }
  TYPES = [:movie, :tv_episode, :tv_movie, :tv_serie, :video, :video_game]
end
