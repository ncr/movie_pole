class AddMoreAttrToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :year, :integer
    add_column :movies, :rating, :integer
    add_column :movies, :votes, :integer    
    add_column :movies, :genre_id, :integer
    add_column :movies, :imdb_id, :integer  
  end

  def self.down
    remove_column(movies, [:year, :rating, :votes, :genre_id, :imdb_id])
  end
end
