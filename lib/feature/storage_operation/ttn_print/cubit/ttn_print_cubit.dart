import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:virok_wms/feature/storage_operation/ttn_print/models/ttn_data.dart';

part 'ttn_print_state.dart';

class TtnPrintCubit extends Cubit<TtnPrintState> {
  TtnPrintCubit() : super(const TtnPrintState());

  Future<TtnData> fetchData(String value) async {
    final String apiUrl =
        'http://192.168.2.50:81/virok_wms/hs/New/get_np_data?DocBarcode=$value';

    const String username = 'Адмін';
    const String password = 'fnk98#L<pH';

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': basicAuth,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return TtnData(
        ttnNumber: data['ttn_number'] ?? '',
        apiKey: data['api_key'] ?? '',
        ttnRef: data['ttn_ref'] ?? '',
        errorMessage: data['ErrorMassage'] ?? '',
      );
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getTtnData(String query, String value) async {
    try {
      if (value.isNotEmpty) {
        emit(state.copyWith(status: TtnPrintStatus.loading));
        final ttnData = await fetchData(value);

        emit(state.copyWith(
          status: TtnPrintStatus.success,
          ttnData: ttnData,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: TtnPrintStatus.failure,
        errorMassage: e.toString(),
      ));
    }
  }

  void clear() {
    emit(state.copyWith(
      status: TtnPrintStatus.initial,
      ttnData: TtnData.empty,
      errorMassage: '',
    ));
  }
}
