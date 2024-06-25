import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/feature/inventory/inventory_by_cells/models/task_model.dart';

import '../models/task_noms_models.dart';

class InventoryByCellsClient {
  final client = http.Client();

  Future<InventoryByCellsTasksModel> getTasks(String query, String body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String zone = prefs.getString('zone') ?? '';
    String baseUrl = prefs.getString('api') ?? '';
    String password = prefs.getString('password') ?? '';


    final url = '$baseUrl$query $body';
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$zone:$password'))}';

    try {
      final response = await client.post(Uri.parse(url), headers: {
        'Authorization': basicAuth,
        'Content-type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return InventoryByCellsTasksModel.fromJson(json);
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

  Future<CellInventoryTaskNomsModel> getNoms(String query, String body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String zone = prefs.getString('zone') ?? '';
    String baseUrl = prefs.getString('api') ?? '';
    String password = prefs.getString('password') ?? '';


    final url = '$baseUrl$query $body';
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$zone:$password'))}';

    try {
      final response = await client.post(Uri.parse(url), headers: {
        'Authorization': basicAuth,
        'Content-type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return CellInventoryTaskNomsModel.fromJson(json);
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
