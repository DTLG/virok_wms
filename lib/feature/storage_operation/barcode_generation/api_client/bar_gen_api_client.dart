import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:virok_wms/models/nom_model_dto.dart';

class BarcodeGenerationApiCLient {
  final client = http.Client();

  Future<NomsDTO> genBarApi(String query, String body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String zone = prefs.getString('zone') ?? '';
    String baseUrl = prefs.getString('api') ?? '';
    String password = prefs.getString('password') ?? '';

    final url = '$baseUrl$query $body';
    final basicAuth = base64.encode(utf8.encode('$zone:$password'));

    try {
      final response = await client.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Basic $basicAuth',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        return NomsDTO.fromJson(json);
      } else {
        throw SocketException(
            'HTTP request failed with status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending request: $e');
    } finally {
      client.close();
    }
  }
}
