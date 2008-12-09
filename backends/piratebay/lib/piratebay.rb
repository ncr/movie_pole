require 'rubygems'
require 'hpricot'
require 'open-uri'

class PirateBay
	BASE_URI = "http://thepiratebay.org"
	def search( options)
		uri = BASE_URI + "/search/"
		uri << URI.encode(parse_search_options( options ).join("/"))
    doc = Hpricot(open(uri))
		list_items = doc / "table#searchResult / tr"
    results = []
    list_items.each do |list_item|
      result = {}
      result[:title] = parse_title(list_item)
			result[:about] = parse_about(list_item)
			result[:uri], result[:size], result[:seeders], result[:leechers] = parse_elements(list_item)
      results << result
    end
      { :results => results, :query => options }
	end

	protected
	def parse_search_options( options )
		params =[]
		params << options[:title] if options[:title]
		params << "0" # first page of list
		case options[:sort_by]
			when :name
				params << "1"
			when :size
				params << "5"
			when :seeders
				params << "7"
			else
				params << "9"
		end
		params << "200" # movie type
	end

	def parse_title (list_item)
		list_item.at( "a.detLink").inner_html
	end

	def parse_about (list_item)
		BASE_URI + list_item.at( "a.detLink")["href"]
	end

	def parse_uri (list_item)
		list_item.at( "a.detLink")["href"]
	end

	def parse_elements (list_item)
		tab = []
		list_item.each_child_with_index do |element, index|
			tab << element.at("a")["href"] if index == 7
			tab << element.inner_text.gsub("?", " ") if index == 9
			tab << element.inner_text.to_i if index == 11
			tab << element.inner_text.to_i if index == 13
		end
		tab
	end

end
