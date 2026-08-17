class Playlist{
  String playlistname;
  int songcount;

  Playlist(this.playlistname,this.songcount);

void addsong(){
  songcount++;
}
}
void main()
{
Playlist playlist=Playlist("My Favorites", 0);

playlist.addsong();
playlist.addsong();
playlist.addsong();

print("Playlist Name: ${playlist.playlistname}");
print("Final Song Count: ${playlist.songcount}");
}
