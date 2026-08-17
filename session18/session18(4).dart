class Movie
{
  String title;
  String ? gen;
  int releaseyear;

  Movie({
    required this.title,
    this.gen,
    this.releaseyear=2024
});

}
void main()
{
  Movie movie = Movie(title: "3 Idiots");

  print("title: ${movie.title}");
  print("Genre: ${movie.gen ?? "Not provided"}");
  print("Release Year: ${movie.releaseyear}");
}