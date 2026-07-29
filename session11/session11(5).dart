import 'dart:io';
void main()
{
  print("enter your favorite food \n pizza\n burger \n dosa\nbiryani");
  var food=int.parse(stdin.readLineSync().toString());
  switch(food)
  {
    case "pizza":
      print(" ");

    case "burger":
      print("Can add products");

    case "dosa":
      print(" Can browse and purchase");

    case "biryani":
      print("Can add products");
  }
}