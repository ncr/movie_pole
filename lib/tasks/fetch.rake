namespace :fetch do  

  task :prepare => :environment do
    puts "..require dependencies.."
    Dir.glob(File.join( RAILS_ROOT, 'app', 'models', '*.rb')).each { |file| require_dependency file }
    puts "..load IMDB.."
    @full_info = IMDB::FullInformation.new
    @now_playing = IMDB::NowPlaying.new
  end

  desc 'Fetch movies'
  task :movies => :prepare do
    fetch_movies_from_this_month
  end

  desc 'Fetch torrents'
  task :torrents => :prepare do
    update_all_torrents
  end

  def fetch_movies_from_this_month    
    ids = current_month_imdb_ids.reject{|id| Movie.find_by_id(id)}
    movies = ids.flatten.map {|id| @full_info.information(id)[:result] }
    bulk_save_movies(movies)
  end

  def current_month_imdb_ids
    puts "..current_month_imdb_ids.."
    @now_playing.movies(Time.now.year, Time.now.month)[:results].map{|movie| movie[:imdb_id]}
  end

  def bulk_save_movies(movies = [])
    puts "..bulk_save_movies.."    
    movies.each do |m|
      Movie.create do |movie|
        movie.title = m[:title]
        movie.imdb_id = m[:imdb_id].to_i
        movie.rating = m[:rating].to_i
        movie.votes = m[:votes].to_i
        movie.year = m[:year].to_i
      end
    end    
  end

  def update_all_torrents
    puts "..update_all_torrents.."
    Movie.all.each { |m| m.update_torrent }
  end
end

