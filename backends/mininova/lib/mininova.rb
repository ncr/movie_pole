require 'rubygems'
require 'hpricot'
require 'open-uri'

class Mininova
  
  BASE_URL = "http://www.mininova.org"
  
  # Hit following address and observe.
  # http://www.mininova.org/search/californication%20s02e09/seeds
  # http://www.mininova.org/imdb/?imdb=434343
  
  def search(query)
    source = "#{BASE_URL}/search/#{URI.encode(query)}/seeds"
    results = fetch_results(source)    
    { :query => query, :results => results }
  end

  def from_imdb(imdb_id)
    source = "#{BASE_URL}/imdb/?imdb=#{imdb_id}"
    results = fetch_results(source)
    { :imdb_id => imdb_id, :results => results }
  end

  def fetch_results(source)
    doc = Hpricot(open(source))
    torrents = (doc/"a.dl").map{|a| BASE_URL + a["href"]}
    torrents.map { |url|  { :source => source,:file   => url } }
  end
end
