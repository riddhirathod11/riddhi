class UserProfile {
  String name;
  int age;
  String email;

  UserProfile({
    required this.name,
    required this.age,
    required this.email,
  });
}

void main() {
  UserProfile user = UserProfile(
    name: 'riddhi',
    age: 21,
    email: 'riddhi@gmail.com',
  );

  print('Name: ${user.name}');
  print('Age: ${user.age}');
  print('Email: ${user.email}');
}