class Movie{
  String title;
  String genre;
  int releaseYear;

Movie(this.title,this.genre,this.releaseYear);
}
void main()
{

  Movie movie1=Movie("war","action",2019);
  Movie movie2=Movie("shershaah", "war", 2021);

  print("name:${movie1.title}");
  print("genre:${movie1.genre}");
  print("releaseyear:${movie1.releaseYear}");

  print("name:${movie2.title}");
  print("genre:${movie2.genre}");
  print("releaseyear:${movie2.releaseYear}");

}