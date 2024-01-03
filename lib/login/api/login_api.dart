import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/login/api/user_model.dart';

class LoginApi {
  final client = http.Client();

  Future<int> logIn(String username, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String baseUrl = prefs.getString('api') ?? '';
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    http.Client client = http.Client();
    try {
      final response = await client.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': basicAuth,
        },
      );

      return response.statusCode;
    } catch (e) {
      rethrow;
    } finally {
      client.close();
    }
  }

  Future<Users> getUser(String path) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String baseUrl = prefs.getString('api') ?? '';
    final basicAuth = 'Basic ${base64Encode(utf8.encode('AdminTSD:Vir20Ok'))}';
    http.Client client = http.Client();
    try {
      final response = await client.post(
        Uri.parse('${baseUrl}get_users_list'),
        headers: {
          'Authorization': basicAuth,
        },
      );
      Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
      return Users.fromJson(json);
    } catch (e) {
      rethrow;
    } finally {
      client.close();
    }
  }
}
