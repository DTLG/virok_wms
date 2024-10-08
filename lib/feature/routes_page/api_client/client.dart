import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/feature/routes_page/model/route.dart';

import '../model/order.dart';

class ApiClient {
  // Метод для отримання базового API шляху, авторизації та хедерів
  Future<Map<String, String>> _getCommonHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    String apiUrl = prefs.getString('api') ?? '';
    String username = prefs.getString('zone') ?? '';
    String password = prefs.getString('password') ?? '';

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    return {
      'apiUrl': apiUrl,
      'Authorization': basicAuth,
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }

  Future<RoutesResponse?> fetchRoutes() async {
    final headers = await _getCommonHeaders();
    final String apiUrl = headers['apiUrl'] ?? '';
    final response = await http.get(
      Uri.parse('$apiUrl/get_routes'), // URL з передачею GUID
      headers: {
        'Authorization': headers['Authorization'] ?? '',
        'Content-Type': headers['Content-Type'] ?? '',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return RoutesResponse.fromJson(data);
    } else {
      throw Exception('Failed to load routes');
    }
  }

  Future<RouteData> fetchOrderData(String routeGuid) async {
    final headers = await _getCommonHeaders();
    final String apiUrl = headers['apiUrl'] ?? '';

    final response = await http.get(
      Uri.parse(
          '$apiUrl/route_info?route_guid=$routeGuid'), // URL з передачею GUID
      headers: {
        'Authorization': headers['Authorization'] ?? '',
        'Content-Type': headers['Content-Type'] ?? '',
      },
    );

    if (response.statusCode == 200) {
      // Parse the JSON response as a Map
      final Map<String, dynamic> data =
          jsonDecode(utf8.decode(response.bodyBytes));

      // Convert the map to a RouteData object
      return RouteData.fromJson(data);
    } else {
      throw Exception('Failed to load RouteData');
    }
  }

  Future<String> routeScan(
      String routeGuid, String barcode, String docGuid) async {
    final headers = await _getCommonHeaders();
    final String apiUrl = headers['apiUrl'] ?? '';

    final response = await http.get(
      Uri.parse(
          '$apiUrl/route_scan?route_guid=$routeGuid&order_barcode=$barcode&doc_guid=$docGuid'), // URL з передачею GUID
      headers: {
        'Authorization': headers['Authorization'] ?? '',
        'Content-Type': headers['Content-Type'] ?? '',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(utf8.decode(response.bodyBytes));

      // Parse the JSON response as a Map
      // Convert the map to a RouteData object
      return data['ErrorMassage'];
    } else {
      throw Exception('Failed to load RouteData');
    }
  }

  Future<RouteData> createRouteDoc(String routeGuid) async {
    final headers = await _getCommonHeaders();
    final String apiUrl = headers['apiUrl'] ?? '';

    final response = await http.get(
      Uri.parse(
          '$apiUrl/create_route_doc?route_guid=$routeGuid'), // URL з передачею GUID
      headers: {
        'Authorization': headers['Authorization'] ?? '',
        'Content-Type': headers['Content-Type'] ?? '',
      },
    );

    if (response.statusCode == 200) {
      // Parse the JSON response as a Map
      final Map<String, dynamic> data =
          jsonDecode(utf8.decode(response.bodyBytes));

      // Convert the map to a RouteData object
      return RouteData.fromJson(data);
    } else {
      throw Exception('Failed to load RouteData');
    }
  }
}
