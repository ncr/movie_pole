xml.instruct!
xml.rss("version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title "New Movies from Movie Pole"
    xml.language "en-gb"

    for movie in @movies
      xml.item do
        xml.pubDate movie.created_at.rfc822
        xml.title h(movie.title)
        xml.imdb_id movie.imdb_id
        xml.description do
          xml << h(render(:partial => movie))
        end
      end
    end
  end
end
