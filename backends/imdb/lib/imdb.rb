require "open-uri"
require "hpricot"

class IMDB
  BASE_URI = "http://www.imdb.com"
  HEADERS = { "User-Agent" => "IMRb/0.0" }

  def movies(options = {})
    power_search(options.merge(:only => :movie))
  end

  def power_search(options)
    uri = BASE_URI + "/List?"
    uri << URI.encode(parse_power_search_options(options).join("&&"))
    allowed_types = allowed_types(options)
    doc = Hpricot(open(uri, HEADERS))
    list_items = doc / "ol" / "li"
    results = []
    list_items.each do |list_item|
      type = parse_type(list_item)
      next unless allowed_types.include? type
      result = {}
      result[:type] = type
      result[:title] = parse_title(list_item)
      result[:year] = parse_year(list_item)
      result[:type] = parse_type(list_item)
      result[:rating] = parse_rating(list_item)
      result[:votes] = parse_votes(list_item)
      result[:imdb_id] = parse_imdb_id(list_item)
      result[:uri] = parse_uri(list_item)
      result.delete_if { |key, value| value.nil? } # compact
      results << result
    end
    { :results => results, :query => options }
  end

  protected

  def parse_power_search_options(options)
    params = []

    allowed_types = allowed_types(options)

    # parse types
    params << "tvm=" + (allowed_types.include?(:tv_movie) ? "on" : "off")
    params << "vid=" + (allowed_types.include?(:video) ? "on" : "off")
    params << "tv=" + (allowed_types.include?(:tv_serie) ? "on" : "off")
    params << "ep=" +  (allowed_types.include?(:tv_episode) ? "on" : "off")

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

    # parse title keywords option
    params << "words=#{options[:title_keywords]}" if options[:title_keywords]

    params
  end

  def allowed_types(options)
    types = [:movie, :tv_episode, :tv_movie, :tv_serie, :video, :video_game]
    if options.has_key? :only and options.has_key? :except
      raise ArgumentError, "using :except and :only at the same time is not allowed"
    elsif options.has_key? :only
      types &= [options[:only]].flatten # because to_a gives a warning
    elsif options.has_key? :except
      types -= [options[:except]].flatten
    end
    types
  end

  def parse_title(list_item)
    a_html = list_item.at("a").inner_html
    a_html.gsub(/\(\d{4}(\/[^)]+)?\)|\(TV\)|\(V\)|\(VG\)/, "").strip.squeeze(" ")
  end

  def parse_uri(list_item)
    a_href = list_item.at("a")["href"]
    "#{BASE_URI}#{a_href}"
  end

  def parse_imdb_id(list_item)
    a_href = list_item.at("a")["href"]
    match = a_href.match(/\/title\/tt(\d+)/)
    match[1] if match
  end

  def parse_year(list_item)
    a_html = list_item.at("a").inner_html
    match = a_html.match(/\((\d{4})(\/[^)]+)?\)/)
    match[1] if match
  end

  def parse_rating(list_item)
    (list_item / "small").each do |small|
      match = small.inner_html.match(/(\d{1,2}.\d)\/10.*\(\d+.*votes\)/)
      return match[1].to_f if match
    end
    nil
  end

  def parse_votes(list_item)
    (list_item / "small").each do |small|
      match = small.inner_html.match(/\d\.\d\/10.*\((\d+).*votes\)/)
      return match[1].to_i if match
    end
    nil
  end

  def parse_type(list_item)
    a_html = list_item.at("a").inner_html
    return :tv_movie if a_html.include? "(TV)"
    return :video_game if a_html.include? "(VG)"
    return :video if a_html.include? "(V)"
    (list_item / "small").each do |small|
      return :tv_serie if small.inner_html.include? "TV Series"
      return :tv_episode if small.inner_html.include? "TV Episode"
    end
    :movie
  end
end
