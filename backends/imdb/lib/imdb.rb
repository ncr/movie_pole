require "rubygems"
require "open-uri"
require "hpricot"

require File.expand_path(File.dirname(__FILE__) + "/power_search")
require File.expand_path(File.dirname(__FILE__) + "/now_playing")
require File.expand_path(File.dirname(__FILE__) + "/full_information")

module IMDB
  BASE_URI = "http://www.imdb.com"
  HEADERS = { "User-Agent" => "IMRb/0.0" }
  TYPES = [:movie, :tv_episode, :tv_movie, :tv_serie, :video, :video_game]
end
