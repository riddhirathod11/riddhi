class ProductUser {
  static int totalUsers = 0;

  ProductUser() {
    totalUsers++;
  }
}

class AdminUser extends ProductUser {}

class CustomerUser extends ProductUser {}

void main() {
  ProductUser user1 = ProductUser();
  AdminUser user2 = AdminUser();
  CustomerUser user3 = CustomerUser();

  print("Total users: ${ProductUser.totalUsers}");
}