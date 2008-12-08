class Movie < ActiveRecord::Base
  named_scope :recent, lambda { {:conditions => ['created_at > ?', 5.days.ago]}}

  belongs_to :genre
  
  validates_presence_of :title, :imdb_id
  validates_uniqueness_of :imdb_id, :title

  def self.fetch_from_this_month
    movies = []
    ids = Movie.latest_ids
    # sciagamy pełne informacje o filmach
    imdb = IMDB::FullInformation.new
    ids.each {|imdb_id| movies << imdb.information(imdb_id)[:result] }
    Movie.bulk_save(movies) # zapis w bazie
  end

  def self.latest_ids
    # sciagamy idki imdb nowosci z tego miesiaca
    IMDB::NowPlaying.new.movies(Time.now.year, Time.now.month)[:results].map{|movie| movie[:imdb_id]}
  end

  protected

  def self.bulk_save(movies = nil)
    count = 0
    movies[0..100].each { |m| count +=1 if Movie.create(:title => m[:title], :imdb_id => m[:imdb_id]).valid? }
    count
  end

  def self.fake_movies
    {:query=>{:month=>6, :year=>2008}, :results=>[{:imdb_id=>"0960144", :title=>"You Don't Mess with the Zohan"}, {:imdb_id=>"0416044", :title=>"Mongol"},
        {:imdb_id=>"0441773", :title=>"Kung Fu Panda"}, {:imdb_id=>"0803057", :title=>"The Promotion"}, {:imdb_id=>"0829098", :title=>"When Did You Last See Your Father?"},
        {:imdb_id=>"0985593", :title=>"Miss Conception"}, {:imdb_id=>"0800080", :title=>"The Incredible Hulk"}, {:imdb_id=>"0949731", :title=>"The Happening"}, {:imdb_id=>"0414426", :title=>"Quid Pro Quo"},
        {:imdb_id=>"0923600", :title=>"Baghead"}, {:imdb_id=>"1093842", :title=>"My Winnipeg"}, {:imdb_id=>"0425061", :title=>"Get Smart"}, {:imdb_id=>"0811138", :title=>"The Love Guru"},
        {:imdb_id=>"0846308", :title=>"Kit Kittredge: An American Girl"}, {:imdb_id=>"0940585", :title=>"Brick Lane"}, {:imdb_id=>"0910970", :title=>"WALL&#183;E"},
        {:imdb_id=>"0493464", :title=>"Wanted"}, {:imdb_id=>"1204298", :title=>"Gunnin' for That #1 Spot"}, {:imdb_id=>"0889134", :title=>"Finding Amanda"}]}
  end

end


