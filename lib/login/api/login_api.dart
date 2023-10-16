import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
}
