import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/models/nom_model_dto.dart';

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
    } finally {
      client.close();
    }
  }

  Future<Map> updateStatus(String docId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';
    String baseUrl = prefs.getString('api') ?? '';

    final url = '${baseUrl}selection_update_status $docId';
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    try {
      // final response = await http.post(Uri.parse(url), headers: {
      //   'Authorization': basicAuth,
      //   'Accept': 'application/json',
      // });

      // if (response.statusCode == 200) {
      //   Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
      //   return {
      //     "status": "0,1 або 2",
      //     "error_massage": "Штрихкод не знайдено або '' "
      //   };
      // } else {
      //   throw Exception(
      //       'HTTP request failed with status ${response.statusCode}');
      // }
      return {
          "status": 1,
          "error_massage": "Штрихкод не знайдено"
        };
    } finally {
      client.close();
    }
  }
}
