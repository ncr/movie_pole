require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe IMDB::PowerSearch, "#parse_search_options" do
  before do
    IMDB::PowerSearch.send(:public, :parse_search_options)
    @power_search = IMDB::PowerSearch.new
  end

  it "should contain default params" do
    params = @power_search.parse_search_options({})
    params.should include("tvm=on")
    params.should include("vid=on")
    params.should include("tv=on")
    params.should include("ep=on")
  end

  it "should parse year option" do
    params = @power_search.parse_search_options(:year => 2008)
    params.should include("year=2008")
  end

  it "should parse year range option" do
    params = @power_search.parse_search_options(:year => 2000..2005)
    params.should include("year_lo=2000")
    params.should include("year_hi=2005")
  end

  it "should parse rating option" do
    params = @power_search.parse_search_options(:rating => 6)
    params.should include("lo-rating=6")
    params.should include("hi-rating=10")
  end

  it "should parse rating range option" do
    params = @power_search.parse_search_options(:rating => 1..5)
    params.should include("lo-rating=1")
    params.should include("hi-rating=5")
  end

  it "should parse votes option" do
    params = @power_search.parse_search_options(:votes => 1000)
    params.should include("votes=1000")
  end

  it "should parse keywords option" do
    params = @power_search.parse_search_options(:title_keywords => "a b c")
    params.should include("words=a b c")
  end
end

describe IMDB::PowerSearch, "using babylon.html fixture" do
  before do
    @power_search = IMDB::PowerSearch.new
    @babylon = open(File.dirname(__FILE__) + "/../fixtures/babylon.html")
    @power_search.stub!(:open).and_return(@babylon)
  end

  it "should parse HTML and return hash" do
    movies = @power_search.search(:only => :movie)
    movies.should have_key(:query)
    movies.should have_key(:results)
    results = movies[:results]
    results.count.should == 1
    result = results.first
    result.should include(:title => "Babylon A.D.")
    result.should include(:year => "2008")
    result.should include(:rating => 5.3)
    result.should include(:votes => 9678)
    result.should include(:uri => "http://www.imdb.com/title/tt0364970/")
    result.should include(:type => :movie)
    result.should include(:imdb_id => "0364970")
  end
end

describe IMDB::PowerSearch, "using notfound.html fixture" do
  before do
    @power_search = IMDB::PowerSearch.new
    @not_found = open(File.dirname(__FILE__) + "/../fixtures/notfound.html")
    @power_search.stub!(:open).and_return(@not_found)
  end

  it "should parse HTML and return hash" do
    movies = @power_search.search(:only => :movie)
    movies.should have_key(:query)
    movies.should have_key(:results)
    movies[:results].should be_empty
  end
end

describe IMDB::PowerSearch, "using monkeys.html fixture" do
  before do
    @power_search = IMDB::PowerSearch.new
    @power_search.stub!(:open).and_return(open(File.dirname(__FILE__) + "/../fixtures/monkeys.html"))
  end

  it "should parse HTML and return hash" do
    movies = @power_search.search(:only => :tv_movie)
    movies.should have_key(:query)
    movies.should have_key(:results)
    results = movies[:results]
    results.count.should == 5

    result = results[0]
    result.should include(:title => "Dana Carvey: Squatting Monkeys Tell No Lies")
    result.should include(:year => "2008")
    result.should include(:rating => 6.7)
    result.should include(:votes => 55)
    result.should include(:uri => "http://www.imdb.com/title/tt1251752/")

    result = results[1]
    result.should include(:title => "Monkey, Monkey, Bottle of Beer, How Many Monkeys Have We Here?")
    result.should include(:year => "1974")
    result.should_not have_key(:rating)
    result.should_not have_key(:votes)
    result.should include(:uri => "http://www.imdb.com/title/tt0211524/")

    result = results[2]
    result.should include(:title => "Monkeys")
    result.should include(:year => "1989")
    result.should include(:rating => 6.6)
    result.should include(:votes => 5)
    result.should include(:uri => "http://www.imdb.com/title/tt0338260/")

    result = results[3]
    result.should include(:title => "Snow Monkeys")
    result.should include(:year => "1994")
    result.should_not have_key(:rating)
    result.should_not have_key(:votes)
    result.should include(:uri => "http://www.imdb.com/title/tt0220050/")

    result = results[4]
    result.should include(:title => "Uncle Gus in: For the Love of Monkeys")
    result.should include(:year => "1999")
    result.should_not have_key(:rating)
    result.should_not have_key(:votes)
    result.should include(:uri => "http://www.imdb.com/title/tt0287070/")
  end
end
