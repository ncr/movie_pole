require "rubygems"
require "open-uri"
require "hpricot"

require "backends/imdb/lib/power_search"
require "backends/imdb/lib/now_playing"
require "backends/imdb/lib/full_information"

module IMDB
  BASE_URI = "http://www.imdb.com"
  HEADERS = { "User-Agent" => "IMRb/0.0" }
  TYPES = [:movie, :tv_episode, :tv_movie, :tv_serie, :video, :video_game]
end
