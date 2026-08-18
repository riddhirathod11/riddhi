class Productuser{
  String name;
  String email;

  Productuser(this.name,this.email);

  void displayinfo()
  {
    print("name:$name");
    print("email:$email");
  }
}
void main()
{
  Productuser user=Productuser("riddhi", "r@gmail.com");

  user.displayinfo();
}