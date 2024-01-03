import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'models/displacement_nom_model_dto.dart';
import 'models/displacement_order_dto.dart';

class DisplacementOrderDataClient {
  final client = http.Client();

  Future<DisplacementNomsDTO> getNoms(String query, String body) async {
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
        'Accept': 'application/json',
      });
  

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return DisplacementNomsDTO.fromJson(json);
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

  Future<DisplacementNomDTO> getNom(String query, String body) async {
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
        'Accept': 'application/json',
      });
    
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return DisplacementNomDTO.fromJson(json);
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

  // Future<void> closeOrder(String query, String body) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();

  //   String username = prefs.getString('username') ?? '';
  //   String password = prefs.getString('password') ?? '';
  //   String baseUrl = prefs.getString('api') ?? '';

  //   final url = '$baseUrl$query $body';
  //   final basicAuth =
  //       'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  //   try {
  //     final response = await http.post(Uri.parse(url), headers: {
  //       'Authorization': basicAuth,
  //       'Accept': 'application/json',
  //     });

  //     if (response.statusCode == 200) {
  //     } else {
  //       throw Exception(
  //           'HTTP request failed with status ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Error sending request: $e');
  //   } finally {
  //     client.close();
  //   }
  // }

  Future<DisplacementOrdersDTO> getOrders(String query, String body) async {
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
        'Accept': 'application/json',
      });
  

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return DisplacementOrdersDTO.fromJson(json);
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
