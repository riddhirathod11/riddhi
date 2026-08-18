class productuser{
  String name;

  productuser(this.name);
}
class  customeruser extends productuser{
  customeruser(String name):super (name);
  void placeorder(String productname){
    print("Order placed for $productname by ${this.name}");
  }
}
void main()
{
  customeruser user1 = customeruser("Riddhi");

  user1.placeorder("Laptop");
}
