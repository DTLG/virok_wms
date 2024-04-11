class Users{
  final List<User> users;

  const Users({required this.users});

  static const empty = Users(users: []);
}

class User {
  final String user;

  User({required this.user});
}