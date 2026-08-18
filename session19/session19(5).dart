class User {
  String name;

  User(this.name);

  void displayInfo() {
    print("User: $name");
  }
}

class SellerUser extends User {
  SellerUser(String name) : super(name);

  @override
  void displayInfo() {
    print("Seller: ${this.name}");
  }
}

class CustomerUser extends User {
  CustomerUser(String name) : super(name);

  @override
  void displayInfo() {
    print("Customer: ${this.name}");
  }
}

void processUser(User user) {
  user.displayInfo();
}

void main() {
  SellerUser seller = SellerUser("riddhi");
  CustomerUser customer = CustomerUser("manshi");

  processUser(seller);
  processUser(customer);
}