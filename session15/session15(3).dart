void main() {
  List favRestaurants = ["Barbeque Nation", "Domino's", "Hocco"];
  favRestaurants.add("The Grand Thakar");
  print(favRestaurants);
  favRestaurants[1] = "Rajwadi Dining Hall";

  print(favRestaurants);
  favRestaurants.removeLast();
  print(favRestaurants);
  favRestaurants.remove("Barbeque Nation");
  print(favRestaurants);
}