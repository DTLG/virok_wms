import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'models/returning_in_nom_model_dto.dart';
import 'models/returning_in_order_dto.dart';

class ReturningInDataClient {
  final client = http.Client();

  Future<ReturningInNomsDTO> getNoms(String query, String body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String zone = prefs.getString('zone') ?? '';
    String baseUrl = prefs.getString('api') ?? '';
    String password = prefs.getString('password') ?? '';

    final url = '$baseUrl$query $body';
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$zone:$password'))}';

    try {
      final response = await client.post(Uri.parse(url), headers: {
        'Authorization': basicAuth,
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return ReturningInNomsDTO.fromJson(json);
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

  Future<ReturningInNomDTO> getNom(String query, String body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String zone = prefs.getString('zone') ?? '';
    String baseUrl = prefs.getString('api') ?? '';
    String password = prefs.getString('password') ?? '';

    final url = '$baseUrl$query $body';
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$zone:$password'))}';

    try {
      final response = await client.post(Uri.parse(url), headers: {
        'Authorization': basicAuth,
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return ReturningInNomDTO.fromJson(json);
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

  Future<void> closeOrder(String query, String body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String zone = prefs.getString('zone') ?? '';
    String baseUrl = prefs.getString('api') ?? '';
    String password = prefs.getString('password') ?? '';

    final url = '$baseUrl$query $body';
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$zone:$password'))}';

    try {
      final response = await client.post(Uri.parse(url), headers: {
        'Authorization': basicAuth,
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
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

  Future<ReturningInOrdersDTO> getOrders(String query, String body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String zone = prefs.getString('zone') ?? '';
    String baseUrl = prefs.getString('api') ?? '';
    String password = prefs.getString('password') ?? '';

    final url = '$baseUrl$query $body';
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$zone:$password'))}';

    try {
      final response = await client.post(Uri.parse(url), headers: {
        'Authorization': basicAuth,
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return ReturningInOrdersDTO.fromJson(json);
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
