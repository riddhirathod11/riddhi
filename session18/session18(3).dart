class Product{
  String productname;
  double price;
  bool isavailable;

  Product(this.productname,this.price,this.isavailable);


void displayproducts()
{
  print("product name:$productname");
  print("price:$price");
  print("Available: ${isavailable ? "Yes" : "No"}");
}
}
void main(){
  Product product=Product("iphone 15pro max",85000,true);
  product.displayproducts();

}