void main() {
  Map product = Map();
  product["title"] = "i-phone";
  product["price"] = "50000";
  product["instock"] = "true";

  product.update("instock", (value) => "false");

  print(product);
}