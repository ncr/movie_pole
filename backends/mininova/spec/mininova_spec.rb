require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe Mininova do
  
  before do
    @mininova = Mininova.new
  end
  
  it "should ask mininova for torrents sorted by seeds" do
    # Mock open-uri open call.
    @mininova.should_receive(:open).with("http://www.mininova.org/search/foo/seeds").and_return("a tag soup")
    @mininova.search("foo")
  end
  
  it "should return a result hash with :query and :results" do
    @mininova.should_receive(:open).and_return("a tag soup")
    search = @mininova.search("foo")
    search[:query].should == "foo"
    search[:results].should be_kind_of(Array)
  end
  
end
