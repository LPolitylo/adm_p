module SongHelpers
  def find_songs
    @songs = Song.all
  end

  def find_song
    Song.where(id: params[:id]).take!
  end

  def create_song
    @song = Song.create(params[:song])
  end
end