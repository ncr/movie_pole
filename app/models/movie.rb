class Movie < ActiveRecord::Base 
  named_scope :most_voted, :order => "votes desc"
  named_scope :best_rated, :order => "rating desc"

  before_validation :sanitize_title

  has_many :torrents
  
  validates_presence_of :title, :imdb_id
  validates_uniqueness_of :imdb_id
  validates_numericality_of [:votes,:rating, :year], :allow_nil => true

  def update_torrent
    Mininova.new.from_imdb(imdb_id)[:results][0..5].each do |torrent|
      self.torrents.create(:title => title, :url => torrent[:file])
    end
  end

  def sanitize_title
    title.strip!
  end

end


