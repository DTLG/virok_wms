import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/login/api/user_model.dart';

class LoginApi {
  final client = http.Client();

  Future<Response> logIn(String zone, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String baseUrl = prefs.getString('api') ?? '';

    baseUrl = '${baseUrl}authentication';
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$zone:$password'))}';
    http.Client client = http.Client();
    try {
      final response = await client.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': basicAuth,
        },
      );

      return response;
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

  Future<bool> checkTsdType(String zone, String pass) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String baseUrl = prefs.getString('api') ?? '';

    final url = '${baseUrl}its_mezonine';
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$zone:$pass'))}';

    try {
      final response = await client.post(Uri.parse(url), headers: {
        'Authorization': basicAuth,
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        return response.body == '1' ? true : false;
      } else {
        throw Exception(
            'HTTP request failed with status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending request: $e');
    } finally {
      client.close();
    }
  }
}
