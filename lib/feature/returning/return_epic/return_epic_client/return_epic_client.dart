import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/return_epic_nom.dart';

class ReturnEpicClient {
  final client = http.Client();

  Future<ReturnEpicNoms> getNoms(String query, String body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String zone = prefs.getString('zone') ?? '';
    String baseUrl = prefs.getString('api') ?? '';
    String password = prefs.getString('password') ?? '';

    final url = '$baseUrl$query $body'.trim();
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$zone:$password'))}';

    try {
      final response = await client.get(Uri.parse(url), headers: {
        'Authorization': basicAuth,
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return ReturnEpicNoms.fromJson(json);
      } else {
        throw Exception(
            'HTTP request failed with status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      client.close();
    }
  }

  Future<ReturnEpicNom> getNom(String query, String body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String zone = prefs.getString('zone') ?? '';
    String baseUrl = prefs.getString('api') ?? '';
    String password = prefs.getString('password') ?? '';

    final url = '$baseUrl$query $body';
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$zone:$password'))}';

    try {
      final response = await client.get(Uri.parse(url), headers: {
        'Authorization': basicAuth,
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return ReturnEpicNom.fromJson(json);
      } else {
        throw Exception(
            'HTTP request failed with status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      client.close();
    }
  }


}
