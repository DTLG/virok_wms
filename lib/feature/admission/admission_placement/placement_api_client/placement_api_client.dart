import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'models/placement_nom_dto.dart';

class PlacementApiClient {
  final client = http.Client();

 

  Future<PlacementNomsDTO> getNoms(String query, String body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';
    String baseUrl = prefs.getString('api') ?? '';

    final url = '$baseUrl$query $body';
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    try {

      final response = await http.post(Uri.parse(url), headers: {
        'Authorization': basicAuth,
        'Content-type': 'application/json',
        'Accept': 'application/json',
      });

      client.close();

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return PlacementNomsDTO.fromJson(json);
      } else {
        throw Exception(
            'HTTP request failed with status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending request: $e');
    }
  }

  Future<PlacementNomDTO> getNom(String query, String body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';
    String baseUrl = prefs.getString('api') ?? '';

    final url = '$baseUrl$query $body';
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    try {

      final response = await http.post(Uri.parse(url), headers: {
        'Authorization': basicAuth,
        'Content-type': 'application/json',
        'Accept': 'application/json',
      });

  

      client.close();

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return PlacementNomDTO.fromJson(json);
      } else {
        throw Exception(
            'HTTP request failed with status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending request: $e');
    }
  }
}
