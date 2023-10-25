import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/models/nom_model_dto.dart';
import 'package:virok_wms/models/order_dto.dart';

class SelectionOrderDataClient {
  final client = http.Client();

  Future<NomsDTO> selectionApi(String query, String body) async {
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
        return NomsDTO.fromJson(json);
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

  Future<void> closeOrderM() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';
    String baseUrl = prefs.getString('api') ?? '';

    final url = '${baseUrl}put_on_tables';
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    try {
      final response = await http.post(Uri.parse(url), headers: {
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
 

  Future<OrdersDTO> getOrders(String query, String body) async {
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
        return OrdersDTO.fromJson(json);
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

  Future<String> setBasketToOrder(String body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';
    String baseUrl = prefs.getString('api') ?? '';

    final url = '${baseUrl}set_basket_to_order $body';
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    try {
      final response = await http.post(Uri.parse(url), headers: {
        'Authorization': basicAuth,
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        return response.body;
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
