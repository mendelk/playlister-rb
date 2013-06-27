require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'json'
require 'open-uri'
require 'cgi'
require 'dm-sqlite-adapter'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/dev.db")

class Artist
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :slug, String, :key => true
  has n, :songs
end

class Song
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :slug, String, :key => true
  belongs_to :artist
  belongs_to :genre
end

class Genre
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :slug, String, :key => true
  has n, :songs
end


DataMapper.finalize.auto_upgrade!


module MendelsPlaylistr

  class App < Sinatra::Base

    get '/' do
      "Hello"
    end

    get '/artists' do
      @artists = Artist.all
      erb :'artists/index'
    end

    get '/artists/new' do
      erb :'artists/new'
    end

    get '/artists/:slug' do |slug|
      @artist = Artist.first(slug:slug)
      erb :'artists/show'
    end

    get '/artist/:slug/edit' do |id|
      @artist = Artist.first(slug:slug)
      erb :'artists/edit'
    end

    post '/artists' do
      # student = Student.new
      # student.from_hash(params[:student])

      # if student.save
      #   redirect '/students'
      # else
      #   redirect '/students/new'
      # end
    end

    put '/artists/:slug' do |slug|
      @artist = Artist.first(slug:slug)

      # if student.save
      #   redirect "/students/#{id}"
      # else
      #   redirect "/students/#{id}/edit"
      # end
    end

    # delete '/students/:id' do |id|
    #   student = Student.find(id)
    #   student.destroy!
    #   redirect "/students"
    # end

    get '/songs' do
      @songs = Song.all
      erb :'songs/index'
    end

    get '/songs/new' do
      erb :'songs/new'
    end

    get '/songs/:slug' do |slug|
      @song = Song.first(slug:slug)
      @youtube_id = JSON.parse(open("https://gdata.youtube.com/feeds/api/videos?q=#{CGI.escape(@song.name)}+#{CGI.escape(@song.artist.name) if @song.artist}&&max-results=1&alt=json").read)["feed"]["entry"].first["id"]["$t"].split("/").last
      erb :'songs/show'
    end

    get '/genres' do
      @genres = Genre.all
      erb :'genres/index'
    end

    get '/genres/new' do
      erb :'genres/new'
    end

    get '/genres/:slug' do |slug|
      @genre = Genre.first(slug:slug)
      erb :'genres/show'
    end



    get '/students/:id/edit' do |id|
      @student = Student.find(id)
      erb :'students/edit'
    end

    post '/students' do
      student = Student.new
      student.from_hash(params[:student])

      if student.save
        redirect '/students'
      else
        redirect '/students/new'
      end
    end

    put '/students/:id' do |id|
      student = Student.find(id)
      student.from_hash(params[:student])

      if student.save
        redirect "/students/#{id}"
      else
        redirect "/students/#{id}/edit"
      end
    end

    delete '/students/:id' do |id|
      student = Student.find(id)
      student.destroy!
      redirect "/students"
    end

  end
end