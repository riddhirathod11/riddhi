
String getUserDisplayName(Map user) {
    return '${user['lastName']}, ${user['firstName']}';
  }

  void main() {
    Map user = {
      'firstName': 'Riddhi',
      'lastName': 'Rathod',
    };

    print(getUserDisplayName(user));
  }
