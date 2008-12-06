require "open-uri"
require "hpricot"

class IMDB
  BASE_URI = "http://www.imdb.com"
  HEADERS = { "User-Agent" => "IMRb/0.0" }

  def movies(options = {})
    uri = BASE_URI + "/List?"
    uri << URI.encode(parse_list_options(options).join("&&"))
    html = Hpricot(open(uri, HEADERS))
    movies_html = html / "ol" / "li"
    results = movies_html.inject([]) do |movies, movie_html|
      movie = {}
      # parse uri
      uri = movie_html.at("a")["href"]
      movie[:uri] = "#{BASE_URI}#{uri}"

      # parse title
      title = movie_html.at("a").inner_html
      movie[:title] = sanitize_title(title)

      # parse year
      if match = title.match(/\((\d{4})\)/)
        movie[:year] = match[1]
      end

      if match = movie_html.at("small").inner_html.match(/(\d\.\d)\/10.*\((\d+).*votes\)/)
        movie[:rating] = match[1]
        movie[:votes] = match[2]
      end

      movies << movie
    end
    { :results => results, :query => options }
  end

  protected

  def parse_list_options(options)
    params = ["tvm=only"]

    # parse year option
    case options[:year]
    when Range
      params << "year_lo=#{options[:year].first}"
      params << "year_hi=#{options[:year].last}"
    else
      params << "year=#{options[:year]}" if options[:year]
    end

    # parse rating option
    case options[:rating]
    when Range
      params << "lo-rating=#{options[:rating].first}"
      params << "hi-rating=#{options[:rating].last}"
    else
      if options[:rating]
        params << "lo-rating=#{options[:rating]}"
        params << "hi-rating=10"
      end
    end

    # parse votes option
    params << "votes=#{options[:votes]}" if options[:votes]

    # parse keywords option
    params << "words=#{options[:keywords]}" if options[:keywords]

    params
  end

  def sanitize_title(title)
    title.gsub(/\(\d{4}\)|\(TV\)/, "").strip.squeeze(" ")
  end
end
