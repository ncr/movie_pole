require "hpricot"
require "xmlrpc/client"
require "stringio"

class OpenSubtitles
  HOST = "http://www.opensubtitles.org/xml-rpc"

  USER_AGENT = "OpenSubtitlesRb/0.0"

  def subtitles(options)
    result = call("SearchSubtitles", [options])
    if result["data"]
      result = { :query => options, :results => result["data"] }
    else
      result = { :query => options, :results => [] }
    end
    result
  end

  protected

  def parse_search_options(options)
    params = {}

    params["imdbid"] = options[:imdb_id] if options.has_key? :imdb_id
    params["sublanguageid"] = options[:language] if options.has_key? :language

    params
  end

  def call(method, args)
    client = XMLRPC::Client.new2(HOST)
    login_result = client.call("LogIn", "", "", "", USER_AGENT)
    token = login_result["token"] if (200...300).include? login_result["status"].to_i
    method_result = client.call(method, token, args)
    puts logout_result = client.call("LogOut", token)
    method_result
  end
end
