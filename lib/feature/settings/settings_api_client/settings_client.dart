import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/feature/settings/models/device_ids.dart';

import 'package:http/http.dart' as http;

class SettingsClient {
  final client = http.Client();

  Future<DeviceIds> getListId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String zone = prefs.getString('zone') ?? '';
    String baseUrl = prefs.getString('api') ?? '';
    String password = prefs.getString('password') ?? '';

    final url =
        '$baseUrl${'Get_devices_list'}';
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$zone:$password'))}';

    try {
      final response = await client.post(Uri.parse(url), headers: {
        'Authorization': basicAuth,
        'Content-type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return DeviceIds.fromJson(json);
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
