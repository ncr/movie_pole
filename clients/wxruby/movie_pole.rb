#!/usr/bin/env ruby
require "rubygems"
require "wx"
require "feed-normalizer"
require "open-uri"

require "movie_pole_main"

Wx::App.run do
  Wx::Timer.every(25) { Thread.pass } # executes ruby's green threads
  Wx::XmlResource.get.load("movie_pole.xrc")
  self.app_name = "Movie Pole"
  frame = MoviePoleMain.new
  frame.show
end
