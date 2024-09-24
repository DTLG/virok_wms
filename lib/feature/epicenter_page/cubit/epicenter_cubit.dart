import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/feature/epicenter_page/client/api_client.dart';
import 'package:virok_wms/feature/epicenter_page/model/document.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';
import 'package:virok_wms/models/barcode_model.dart';
import 'package:virok_wms/models/noms_model.dart';
part 'epicenter_state.dart';

class EpicenterCubit extends Cubit<EpicenterState> {
  EpicenterCubit() : super(EpicenterInitial());

  Future<void> fetchDocuments() async {
    emit(EpicenterLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final path = prefs.getString('api');
      String apiUrl = '${path}get_epicentr_table_list';
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
        final List<Document> documents = (data['docs'] as List)
            .map((doc) => Document.fromJson(doc))
            .toList();

        emit(EpicenterLoaded(documents));
      } else {
        emit(EpicenterError('Error: ${response.statusCode}'));
      }
    } catch (e) {
      emit(EpicenterError(e.toString()));
    }
  }
}

// Future<List<DefectiveNom>?> getMovingData(String doc_number) async {
//   final prefs = await SharedPreferences.getInstance();
//   final path = prefs.getString('api');
//   String apiUrl = '${path}get_service_moving_data?doc_number=$doc_number';
//   String username = prefs.getString('zone') ?? '';
//   String password = prefs.getString('password') ?? '';
//   String basicAuth =
//       'Basic ${base64Encode(utf8.encode('$username:$password'))}';
//   final response = await http.get(
//     Uri.parse(apiUrl),
//     headers: <String, String>{
//       'Authorization': basicAuth,
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//   );

//   if (response.statusCode == 200) {
//     final data = jsonDecode(utf8.decode(response.bodyBytes));

//     List<dynamic> nomsJson = data['noms'];
//     return nomsJson.map((json) => DefectiveNom.fromJson(json)).toList();
//   } else {
//     return null;
//   }
// }
