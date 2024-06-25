import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePageApiCLient {
  final client = http.Client();


  Future<int> getOrders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String zone = prefs.getString('zone') ?? '';
    String baseUrl = prefs.getString('api') ?? '';
    String password = prefs.getString('password') ?? '';


    final url = '$baseUrl${"get_orders_list"}';
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$zone:$password'))}';

    try {
      final response = await client.post(Uri.parse(url), headers: {
        'Authorization': basicAuth,
        'Content-type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return json['orders'].length;
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
