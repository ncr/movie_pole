require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe IMDB, "using babylon.html fixture" do
  before do
    @imdb = IMDB.new
    @imdb.stub!(:open).and_return(open(File.dirname(__FILE__) + "/../fixtures/babylon.html"))
  end

  it "should parse HTML and return hash" do
    movies = @imdb.movies
    movies.should include(:query => {})
    movies.should have_key(:results)
    results = movies[:results]
    results.count.should == 1
    result = results.first
    result.should include(:title => "Babylon A.D.")
    result.should include(:year => "2008")
    result.should include(:rating => "5.3")
    result.should include(:votes => "9678")
    result.should include(:uri => "http://www.imdb.com/title/tt0364970/")
  end
end

describe IMDB, "using notfound.html fixture" do
  before do
    @imdb = IMDB.new
    @imdb.stub!(:open).and_return(open(File.dirname(__FILE__) + "/../fixtures/notfound.html"))
  end

  it "should parse HTML and return hash" do
    movies = @imdb.movies
    movies.should include(:query => {})
    movies.should have_key(:results)
    movies[:results].should be_empty
  end
end

describe IMDB, "using monkeys.html fixture" do
  before do
    @imdb = IMDB.new
    @imdb.stub!(:open).and_return(open(File.dirname(__FILE__) + "/../fixtures/monkeys.html"))
  end

  it "should parse HTML and return hash" do
    movies = @imdb.movies
    movies.should include(:query => {})
    movies.should have_key(:results)
    results = movies[:results]
    results.count.should == 5

    result = results[0]
    result.should include(:title => "Dana Carvey: Squatting Monkeys Tell No Lies")
    result.should include(:year => "2008")
    result.should include(:rating => "6.7")
    result.should include(:votes => "55")
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
    result.should include(:rating => "6.6")
    result.should include(:votes => "5")
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
