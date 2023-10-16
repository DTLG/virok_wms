import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/models/order.dart';

class SelectionOrderHeadClient {
  final client = http.Client();

  Future<OrdersDTO> getOrders(String query, String body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';
    String baseUrl = prefs.getString('api') ?? '';

    final url = '$baseUrl/$query $body';
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    http.Client client = http.Client();
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': basicAuth,
          'Accept': 'application/json',
          'Charset': 'utf-8',
        },
      );

      if (response.statusCode == 200) {
        print(utf8.decode(response.bodyBytes));
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return OrdersDTO.fromJson(json);
      } else {
        throw Exception(
            'HTTP request failed with status ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error sending request: $e');
    } finally {
      client.close();
    }
  }
}
