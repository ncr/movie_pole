class CreateTorrents < ActiveRecord::Migration
  def self.up
    create_table :torrents do |t|
      t.string :title, :about, :url, :size
      t.integer :seeders, :leechers
      t.references :movie
      t.timestamps
    end
  end

  def self.down
    drop_table :torrents
  end
end