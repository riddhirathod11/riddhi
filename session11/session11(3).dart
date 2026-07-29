import "dart:io";
void main(){
  print("enter your username");
  var username=stdin.readLineSync().toString();

  print("enter your password");
  var pass=stdin.readLineSync().toString();

  if(username=="user123")
  {
    print("your username is correct");
  }
  if(pass=="pass123")
  {

    print("your password is correct");
  }


}