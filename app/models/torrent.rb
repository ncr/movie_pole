class Torrent < ActiveRecord::Base
  validates_numericality_of :size, :greater_than => 500.megabytes
  belongs_to :movie
  
end
