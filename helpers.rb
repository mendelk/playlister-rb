module Helpers
  def generate_slug(string)
    string.to_s.downcase.scan(/\w+/).join('-')
  end

  def youtube_video_id(song)
    encoded_info = CGI.escape(song.name)
    encoded_info << "+#{CGI.escape(song.artist.name)}" if song.artist
    json = open("https://gdata.youtube.com/feeds/api/videos?q=#{encoded_info}&&max-results=1&alt=json").read
    JSON.parse(json)["feed"]["entry"].first["id"]["$t"].split("/").last
  end


end