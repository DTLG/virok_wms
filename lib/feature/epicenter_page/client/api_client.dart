import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/feature/epicenter_page/model/document.dart';
import 'package:virok_wms/feature/epicenter_page/model/label_info.dart';
import 'package:virok_wms/feature/epicenter_page/model/nom.dart';
import 'package:virok_wms/feature/moving_defective_page/widget/toast.dart';

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

  // Метод для отримання номів (товарів)
  Future<List<Nom>> getNoms(String guid) async {
    try {
      final headers = await _getCommonHeaders();
      final String apiUrl = headers['apiUrl'] ?? '';
      final response = await http.get(
        Uri.parse(
            '$apiUrl/get_epicentr_table_doc_data?doc_guid=$guid'), // URL з передачею GUID
        headers: {
          'Authorization': headers['Authorization'] ?? '',
          'Content-Type': headers['Content-Type'] ?? '',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final List<Nom> noms =
            (data['noms'] as List).map((nom) => Nom.fromJson(nom)).toList();
        return noms;
      } else {
        throw Exception('Failed to load Noms');
      }
    } catch (e) {
      throw Exception('Error fetching Noms: $e');
    }
  }

  Future<List<Nom>> docScan(String guid, String barcode, int count) async {
    try {
      final headers = await _getCommonHeaders();
      final String apiUrl = headers['apiUrl'] ?? '';
      final response = await http.get(
        Uri.parse(
            '$apiUrl/epicentr_table_doc_scan?doc_guid=$guid&barcode=$barcode&count=$count'),
        headers: {
          'Authorization': headers['Authorization'] ?? '',
          'Content-Type': headers['Content-Type'] ?? '',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final List<Nom> noms =
            (data['noms'] as List).map((nom) => Nom.fromJson(nom)).toList();
        return noms;
      } else {
        throw Exception('Failed to load Noms');
      }
    } catch (e) {
      throw Exception('Error fetching Noms: $e');
    }
  }

  Future<String> finishDoc(String guid, int placeCount) async {
    try {
      final headers = await _getCommonHeaders();
      final String apiUrl = headers['apiUrl'] ?? '';
      final response = await http.get(
        Uri.parse(
            '$apiUrl/finish_epicentr_table_doc?doc_guid=$guid&place_count=$placeCount'),
        headers: {
          'Authorization': headers['Authorization'] ?? '',
          'Content-Type': headers['Content-Type'] ?? '',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        print(data);
        return data['ErrorMassage'];
      } else {
        throw Exception('Failed to load Noms');
      }
    } catch (e) {
      throw Exception('Error fetching Noms: $e');
    }
  }

  Future<LabelInfo> getLabelInfo(String guid) async {
    try {
      final headers = await _getCommonHeaders();
      final String apiUrl = headers['apiUrl'] ?? '';
      final response = await http.get(
        Uri.parse('$apiUrl/get_order_label_info?doc_guid=$guid'),
        headers: {
          'Authorization': headers['Authorization'] ?? '',
          'Content-Type': headers['Content-Type'] ?? '',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return LabelInfo.fromJson(data);
      } else {
        throw Exception('Failed to load Noms');
      }
    } catch (e) {
      throw Exception('Error fetching Noms: $e');
    }
  }
}
