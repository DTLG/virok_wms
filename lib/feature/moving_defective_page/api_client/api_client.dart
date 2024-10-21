import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/feature/moving_defective_page/model/defective_nom.dart';
import 'package:virok_wms/feature/moving_defective_page/model/service_moving_doc.dart';
import 'package:virok_wms/feature/moving_defective_page/widget/toast.dart';

class ApiClient {
  ApiClient();

  Future<List<DefectiveNom>?> getNoms(String barcode) async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('api');
    String apiUrl =
        '${path}get_service_moving_cell_stock?cell_barcode=$barcode';
    String username = prefs.getString('zone') ?? '';
    String password = prefs.getString('password') ?? '';
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      List<dynamic> nomsJson = data['noms'];
      return nomsJson.map((json) => DefectiveNom.fromJson(json)).toList();
    } else {
      return null;
    }
  }

  Future<List<DefectiveNom>?> setNoms(String barcode) async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('api');
    String apiUrl = '${path}create_service_moving?cell_barcode=$barcode';
    String username = prefs.getString('zone') ?? '';
    String password = prefs.getString('password') ?? '';
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      List<dynamic> nomsJson = data['noms'];
      return nomsJson.map((json) => DefectiveNom.fromJson(json)).toList();
    } else {
      return null;
    }
  }

  Future<List<DefectiveNom>?> getMovingData(String doc_number) async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('api');
    String apiUrl = '${path}get_service_moving_data?doc_number=$doc_number';
    String username = prefs.getString('zone') ?? '';
    String password = prefs.getString('password') ?? '';
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      List<dynamic> nomsJson = data['noms'];
      return nomsJson.map((json) => DefectiveNom.fromJson(json)).toList();
    } else {
      return null;
    }
  }

  Future<List<ServiceMovingDoc>?> getDocs() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('api');
    String apiUrl = '${path}service_moving_list';
    String username = prefs.getString('zone') ?? '';
    String password = prefs.getString('password') ?? '';
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization': basicAuth,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));

        if (!data.containsKey('service_moving_docs')) {
          return null;
        }

        final List<dynamic>? docsJson =
            data['service_moving_docs'] as List<dynamic>?;

        if (docsJson == null) {
          showToast('No documents found');
          return null;
        }

        return docsJson
            .map(
                (doc) => ServiceMovingDoc.fromJson(doc as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load service moving docs');
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<DefectiveNom>?> getCell(String barcode) async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('api');
    String apiUrl =
        '${path}get_service_moving_cell_stock?cell_barcode=$barcode';
    String username = prefs.getString('zone') ?? '';
    String password = prefs.getString('password') ?? '';
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(utf8.decode(response.bodyBytes));

      final String? errorMessage = data['ErrorMassage'] as String?;
      if (errorMessage != 'OK' && errorMessage != null) {
        showToast(errorMessage);
        return null;
      }

      final List<dynamic>? docsJson = data['noms'] as List<dynamic>?;
      if (docsJson == null) {
        showToast('No documents found');
        return null;
      }

      return docsJson
          .map((doc) => DefectiveNom.fromJson(doc as Map<String, dynamic>))
          .toList();
    } else {
      return null;
    }
  }

  Future<bool> confirmMoving(String doc_number, String bc_label) async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('api');
    String apiUrl =
        '${path}confirm_service_moving?doc_number=$doc_number&defect_cell_barcode=$bc_label';
    String username = prefs.getString('zone') ?? '';
    String password = prefs.getString('password') ?? '';
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(utf8.decode(response.bodyBytes));

      // Перевірка на наявність поля 'ErrorMassage'
      if (data['ErrorMassage'] == 'OK') {
        return true;
      } else {
        showToast(data['ErrorMassage'].toString());
        return false;
      }
    } else {
      throw Exception('Failed to load service moving docs');
    }
  }
}
