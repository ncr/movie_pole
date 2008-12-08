module IMDB
  class FullInformation
    def information(imdb_id)
      uri = "#{BASE_URI}/title/tt#{imdb_id}/"
      doc = Hpricot(open(uri, HEADERS))
      main_div = doc / "div#tn15main"
      result = { :query => { :imdb_id => imdb_id }}

      info = {}
      info[:title] = parse_title(main_div)
      info[:year] = parse_year(main_div)
      info[:rating] = parse_rating(main_div)
      info[:votes] = parse_votes(main_div)
      info[:directors] = parse_directors(main_div)
      info[:writers] = parse_writers(main_div)
      info[:release_date] = parse_release_date(main_div)
      info[:genres] = parse_genres(main_div)
      info[:tagline] = parse_tagline(main_div)
      result[:result] = info
      result
    end

    protected

    def parse_title(main_div)
      h1 = (main_div / "h1")
      h1.inner_html[/[^<]+/].strip.squeeze(" ")
    end

    def parse_year(main_div)
      a = main_div / "h1/span/a"
      a.inner_html
    end

    def parse_rating(main_div)
      b = main_div / "div.rating" / "b"
      b.inner_html[/\d{1,2}\.\d/].to_f
    end

    def parse_votes(main_div)
      a = main_div / "div.rating" / "a"
      a.inner_html.gsub(/[^\d]/, "").to_i
    end

    def parse_directors(main_div)
      anchors = main_div / "div#director-info/a"
      anchors.inject([]) do |result, a|
        result << a.inner_text if a["href"].include? "name"
        result
      end
    end

    def parse_writers(main_div)
      anchors = main_div / "div.info:contains(Writers)/a"
      anchors.inject([]) do |result, a|
        result << a.inner_text if a["href"].include? "name"
        result
      end
    end

    def parse_release_date(main_div)
      text = (main_div / "div.info:contains(Release)").inner_text
      date = text[/\d{1,2} (January|February|March|April|May|June|July|August|October|September|November|December) \d{4}/]
      Date.parse(date) if date
    end

    def parse_genres(main_div)
      anchors = main_div / "div.info:contains(Genre)/a"
      anchors.inject([]) do |result, a|
        result << a.inner_text if a["href"].include? "Genres"
        result
      end
    end

    def parse_tagline(main_div)
      # BUGGY - 'more'
      (main_div / "div.info:contains(Tagline)").inner_text.gsub("\nTagline:\n", "").strip
    end
  end
end
