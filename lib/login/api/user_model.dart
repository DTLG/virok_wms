import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class Users{
    final List<User> users;

  Users({required this.users});


  factory Users.fromJson(Map<String, dynamic> json) =>
      _$UsersFromJson(json);
}


@JsonSerializable()
class User {
    final String? user
    ;

    User({
        required this.user,
    });

    factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

}



