require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe IMDB::NowPlaying, "with 2009-07 fixture" do

  before do
    @now_playing = IMDB::NowPlaying.new
    @now_playing.stub!(:open).and_return(open(File.dirname(__FILE__) + "/../fixtures/2009-07.html"))
  end

  it "should parse HTML and return hash with query" do
    result = @now_playing.movies(2009, 07)
    result.should include(:query)
    result[:query].should include(:month)
    result[:query].should include(:year)
  end

  it "should parse HTML and return hash with results" do
    result = @now_playing.movies(2009, 07)
    results = result[:results]
    results.should include(:imdb_id => "0417741", :title => "Harry Potter and the Half-Blood Prince")
    results.should include(:imdb_id => "0775552", :title => "They Came from Upstairs")
  end
end
