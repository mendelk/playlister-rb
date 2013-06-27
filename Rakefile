require_relative 'sinatra_app'

task :generate do
  require 'find'
  class Scraper
    class << self
      def get_files(directory)
        files = []
        Find.find(directory) do |file|
          files << file.split("/").last if file.match(/\.mp3\Z/)
        end
        files
      end
      def add_to_db(file)
        regex = file.match(/(?<artist_song>.*)\[(?<genre>.+)\]/)
        artist_name, song_name = regex[:artist_song].split(' - ').collect(&:strip)
        genre_name = regex[:genre]
        artist = Artist.first_or_create({name: artist_name},{slug: generate_slug(artist_name)})
        genre = Genre.first_or_create({name:genre_name}, {slug: generate_slug(genre_name)})
        Song.first_or_create({name:song_name},{artist: artist, genre: genre, slug: generate_slug(song_name)})
      end
      def generate_slug(string)
        string.to_s.downcase.scan(/\w+/).join('-')
      end
    end
  end

  Scraper.get_files('data').each{|mp3_file|Scraper.add_to_db(mp3_file)}
end