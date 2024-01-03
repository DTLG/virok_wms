import 'package:virok_wms/login/api/login_api.dart';
import 'package:virok_wms/login/users.dart';

class LoginRepo {
  LoginRepo({LoginApi? loginApi}) : _loginApi = loginApi ?? LoginApi();

  final LoginApi _loginApi;

  Future<Users> getUsers(String path) async {
    final users = await _loginApi.getUser(path);
    return Users(users: users.users.map((e) => User(user: e.user ?? '')).toList());
  }
}
