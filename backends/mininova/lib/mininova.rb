require 'rubygems'
require 'hpricot'
require 'open-uri'

class Mininova
  
  BASE_URL = "http://www.mininova.org"
  
  # Hit following address and observe.
  # http://www.mininova.org/search/californication%20s02e09/seeds
  
  def search(query)
    source = "#{BASE_URL}/search/#{URI.encode(query)}/seeds"
    doc = Hpricot(open(source))

    torrents = (doc/"a.dl").map{|a| BASE_URL + a["href"]}
    
    results = torrents.map do |url|
      {
        :source => source,
        :file   => url
      }
    end
    
    { :query => query, :results => results }
  end
  
end
