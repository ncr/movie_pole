require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe PirateBay do
  before do
		PirateBay.send(:public, :parse_search_options)
    @pirate = PirateBay.new
  end
	
  it "should parse title" do
    params = @pirate.parse_search_options(:title => "varia")
    params.should include("varia")
  end

  it "should parse sort_by name " do
    params = @pirate.parse_search_options(:sort_by => :name)
    params[1].should == "1"
  end

	it "should parse default sorting" do
    params = @pirate.parse_search_options(:title => "something")
    params[2].should == "9"
  end
end

describe PirateBay, "using seventh_seal.html fixture" do
  before do
    @pirate = PirateBay.new
    @pirate.stub!(:open).and_return(open(File.dirname(__FILE__) + "/fixtures/seventh_seal.html"))
  end

	it "should parse HTML and return hash" do
	  torrents = @pirate.search(:title => "string")
		torrents.should have_key(:query)
    torrents.should have_key(:results)
    results = torrents[:results]
    results.count.should == 14
		
		result = results[0]
    result.should include(:uri => "http://torrents.thepiratebay.org/3421658/The_Seventh_Seal_(xvid110-sickboy88).3421658.TPB.torrent")
    result.should include(:about => "http://thepiratebay.org/torrent/3421658/The_Seventh_Seal_(xvid110-sickboy88)")
    result.should include(:seeders => 51)
    result.should include(:leechers => 16)
    result.should include(:size=>"700.08 MiB")

		result = results[13]
    result.should include(:uri =>"http://torrents.thepiratebay.org/4162115/Ronnie_O________Sullivan_147_point_break_at_Crucible_Theatre.4162115.TPB.torrent")
    result.should include(:about => "http://thepiratebay.org/torrent/4162115/Ronnie_O_Sullivan_147_point_break_at_Crucible_Theatre")
    result.should include(:seeders => 1)
    result.should include(:leechers => 0)
    result.should include(:size=>"139.43 MiB")

	end
end

describe PirateBay, "using empty html fixture" do
  before do
    @pirate = PirateBay.new
    @pirate.stub!(:open).and_return(open(File.dirname(__FILE__) + "/fixtures/empty.html"))
  end

  it "should parse HTML and return hash" do
    torrents = @pirate.search(:tilte => "string")
    torrents.should have_key(:query)
    torrents.should have_key(:results)
    torrents[:results].should be_empty
  end
end
