import 'dart:io';
void main()
{
  print("choose role: \n Press 1 for admin \n Press 2 for seller \n Press 3 for buyer");
  var role=int.parse(stdin.readLineSync().toString());
  switch(role)
      {
    case 1:
      print(" Access to all features");

    case 2:
      print("Can add products");

    case 3:
      print(" Can browse and purchase");
  }
}