import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/auth/auth_client/models/user_model.dart';
import 'package:virok_wms/const.dart';

class AuthClient {
  final client = http.Client();

  Future<String> logIn(
      String path, String zone, String password, String user) async {
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$zone:$zonePass'))}';
    try {
      final response = await client.post(
        Uri.parse("${path}authorization?UserName=$user&Password=$password"),
        headers: {
          'Authorization': basicAuth,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));

        return json['ErrorMassage'];
      }
      if (response.statusCode == 401) {
        return 'Не вірний пароль зони';
      } else {
        throw Exception(
            'HTTP request failed with status ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    } finally {
      client.close();
    }
  }

  Future<UsersAndZones> getZones(String path) async {
    final basicAuth = 'Basic ${base64Encode(utf8.encode('AdminTSD:Vir20Ok'))}';
    try {
      final response = await client.post(
        Uri.parse('${path}get_users_list'),
        headers: {
          'Authorization': basicAuth,
        },
      );
      Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
      return UsersAndZones.fromJson(json);
    } catch (e) {
      rethrow;
    } finally {
      client.close();
    }
  }

  Future<bool> checkTsdType(
    String user,
    String zone,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String baseUrl = prefs.getString('api') ?? '';

    final url = '${baseUrl}its_mezonine?DeviceID=&UserName=$user';
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$zone:$zonePass'))}';

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
