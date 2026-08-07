import 'dart:io';
void main()
{
  print("enter your amount");
  var amount = int.parse(stdin.readLineSync().toString());
  {
    if(amount>=500)
      {
        print("'You are eligible for a discount");

      }
    else
      {
        print("'No discount available.");
      }
  }
}