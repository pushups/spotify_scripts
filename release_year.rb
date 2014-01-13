require 'net/http'
require 'json'

# Go through a list of songs and get all of the ones released in
# RELEASE_YEAR

RELEASE_YEAR = '2013'

# File of HTTP Spotify URLs
songs = File.open('songs.txt', 'r')

# All songs from 2013
new_years_songs = File.open("songs_#{RELEASE_YEAR}.txt", 'w')

songs = songs.readlines.map { |x| x.rstrip }
songs.map! {|url| url.sub('open.spotify.com', 'ws.spotify.com').sub('track/', 'lookup/1/.json?uri=spotify:track:')}
songs.each do |url|
  uri = URI(url)
  result = Net::HTTP.get(uri)
  song_json = JSON.parse(result)
  release_date = song_json['track']['album']['released']
  if release_date == RELEASE_YEAR
    new_years_songs.write("#{song_json['track']['artists'][0]['name']} - #{song_json['track']['name']}\n")
  end
  sleep(1.0/10.0)
end