void main()
{
  Map playlist= Map();
  playlist["playlist"]="chill vibes";
  playlist["songs"]=["song a" ,"song b","song c"];
  print(playlist);

  playlist["songs"].add("song d");
  print(playlist);

}