class UsersAndZones {
  final List<User> users;
    final List<Zone> zones;


  UsersAndZones({required this.users, required this.zones});
  factory UsersAndZones.fromJson(Map<String, dynamic> json) => UsersAndZones(
    zones: (json['zones'] as List<dynamic>)
            .map((e) => Zone.fromJson(e as Map<String, dynamic>))
            .toList(),
        users: (json['Users'] as List<dynamic>)
            .map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  static final empty = UsersAndZones(users: [], zones: []);
}

class User {
  final String user;

  User({
    required this.user,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        user: json['user'] ?? '',
      );
}


class Zone {
  final String user;

  Zone({
    required this.user,
  });

  factory Zone.fromJson(Map<String, dynamic> json) => Zone(
        user: json['zone'] ?? '',
      );
}
