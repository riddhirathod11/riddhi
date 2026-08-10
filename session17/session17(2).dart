double  calculateDiscountedPrice(double originalprice,double discountpercentage) {
  double discount = originalprice * (discountpercentage / 100);
  return originalprice - discount;
}
void main()
{
  double price=1500;
  double discount=20;
  double finalprice=calculateDiscountedPrice(price, discount);
print("originalprice:$price");
print("discount:$discount%");
print("final price:$finalprice");

}