import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePageApiCLient{
    final client = http.Client();

  Future<bool> checkTsdType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

 
    String baseUrl = prefs.getString('api') ?? '';

    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';

    final url = '${baseUrl}its_mezonine';
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    try {

      final response = await http.post(Uri.parse(url), headers: {
        'Authorization': basicAuth,
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        return response.body == '0'?false:true;
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