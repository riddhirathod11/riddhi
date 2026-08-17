class Restaurant{
  String name;
  String cuisine;
  double rating;

  Restaurant(this.name,this.cuisine,this.rating);
}
void main()
{
  Restaurant restaurant= Restaurant("Rasika", "indian", 4.5);

  print("Name: ${restaurant.name}");
  print("cuisine: ${restaurant.cuisine}");
  print("rating:${restaurant.rating}");
}