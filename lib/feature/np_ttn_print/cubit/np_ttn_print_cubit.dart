import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/feature/np_ttn_print/models/np_ttn_data.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/np_ttn_print/models/ttn_params.dart';

part 'np_ttn_print_state.dart';


class TtnPrintCubit extends Cubit<TtnPrintState> {
  TtnPrintCubit() : super(const TtnPrintState());

  Future<void> getTtnData(String value) async {
    try {
      value = '111170202405';

      if (value.isNotEmpty) {
        emit(state.copyWith(
          ttnData: TtnData.empty,
          ttnParams: [],
          status: TtnPrintStatus.loading,
          action: MyAction.fetchingInfo,
        ));
        final ttnData = await fetchTtnData(value);
        try {
          final ttnParams = await fetchTtnParams(value);

          emit(state.copyWith(
              status: TtnPrintStatus.success,
              ttnData: ttnData,
              ttnParams: ttnParams,
              errorMassage: 'Дані отримано!'));
        } on Exception catch (e) {
          emit(state.copyWith(
              status: TtnPrintStatus.success,
              ttnData: ttnData,
              ttnParams: [],
              errorMassage: 'Дані отримано!'));
        }
      }
    } catch (e) {
      emit(state.copyWith(
        ttnData: TtnData.empty,
        ttnParams: [],
        status: TtnPrintStatus.failure,
        errorMassage: e.toString(),
        action: MyAction.fetchingInfo,
      ));
    }
  }

  Future<List<TtnParams>> fetchTtnParams(String value) async {
    final prefs = await SharedPreferences.getInstance();
    //
    String apiUrl =
        'http://192.168.2.50:81/virok_wms/hs/New/get_ttn_params?DocBarcode=$value';
    String username = prefs.getString('zone') ?? '';
    String password = prefs.getString('password') ?? '';

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': basicAuth,
      },
    );

    try {
      if (response.statusCode == 200) {
        var responseBody = response.body;
        if (responseBody.isNotEmpty) {
          var decodedJson = jsonDecode(responseBody);

          if (decodedJson is Map<String, dynamic>) {
            var jsonData = decodedJson["ttn_data"];

            if (jsonData is List<dynamic>) {
              List<TtnParams> ttnParamsList = jsonData
                  .where((item) {
                    return item is Map<String, dynamic> &&
                        item["PlaceNumber"] != null &&
                        item["height"] != null &&
                        item["width"] != null &&
                        item["length"] != null &&
                        item["weight"] != null;
                  })
                  .map((item) => TtnParams.fromJson(item))
                  .toList();

              return ttnParamsList;
            } else {
              print("Invalid ttn_data format in response");
            }
          } else {
            print("Invalid JSON format in response");
          }
        } else {
          print("Empty or null response body");
        }
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print("Error fetching and parsing data: $e");
    }
    return []; // Return empty list if any condition fails
  }

  Future<TtnData> fetchTtnData(String value) async {
    final prefs = await SharedPreferences.getInstance();
    String api = prefs.getString('api')!;
    value = '111170202405';

    final String apiUrl = '${api}get_np_data?DocBarcode=$value';

    String username = prefs.getString('zone')!;
    String password = prefs.getString('password')!;

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': basicAuth,
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

      return TtnData(
        ttnNumber: data['ttn_number'] ?? '',
        apiKey: data['api_key'] ?? '',
        ttnRef: data['ttn_ref'] ?? '',
        errorMessage: data['ErrorMassage'] ?? '',
      );
    } else {
      emit(state.copyWith(
        ttnData: TtnData.empty,
        status: TtnPrintStatus.failure,
        errorMassage: 'Не вдалося завантажити дані',
        action: MyAction.waiting,
      ));
      return TtnData.empty;
    }
  }

  void removeTtnParam(TtnParams paramToRemove) {
    final updatedParams = List<TtnParams>.from(state.ttnParams)
      ..remove(paramToRemove);
    for (int i = 0; i < updatedParams.length; i++) {
      updatedParams[i].placeNumber = i + 1;
    }
    emit(state.copyWith(ttnParams: updatedParams));
  }
<<<<<<< HEAD:lib/feature/np_ttn_print/cubit/np_ttn_print_cubit.dart

  void addTtnParam(TtnParams newParam, int index) {
    newParam.placeNumber = index + 1;
=======

  void addTtnParam(TtnParams newParam, int index) {
    newParam.placeNumber = index + 1;

    final updatedParams = List<TtnParams>.from(state.ttnParams)..add(newParam);
    emit(state.copyWith(ttnParams: updatedParams));
  }

  Future<void> saveTtnParams(
      String docBarcode, List<TtnParams> ttnParams) async {
    final prefs = await SharedPreferences.getInstance();
    docBarcode = '111170202405';
>>>>>>> 9c836b5e2f92e87df8d70832726aa8db62c6f1d3:lib/feature/ttn_temp_recreated/cubit/ttn_print_cubit.dart

    final updatedParams = List<TtnParams>.from(state.ttnParams)..add(newParam);
    emit(state.copyWith(ttnParams: updatedParams));
  }

  Future<void> saveTtnParams(String docBarcode, List<TtnParams> ttnParams) async {
    try {
<<<<<<< HEAD:lib/feature/np_ttn_print/cubit/np_ttn_print_cubit.dart
      final prefs = await SharedPreferences.getInstance();
      String username = prefs.getString('zone') ?? '';
      String password = prefs.getString('password') ?? '';

      String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      if (checkIfEmptyExist(ttnParams)) {
        print('There is empty field in ttnParams!');
        return;
      }

      String requestBody = jsonEncode({'ttn_data': ttnParams});

      String apiUrl =
          'http://192.168.2.50:81/virok_wms/hs/New/save_ttn_params?DocBarcode=$docBarcode';

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization': basicAuth,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        print('Дані успішно збережено!');

        String saveDocUrl =
            'http://192.168.2.50:81/virok_wms/hs/New/save_doc?DocBarcode=$docBarcode';

        var docResponse = await http.get(
          Uri.parse(saveDocUrl),
          headers: {
            'Authorization': basicAuth,
          },
        );

        if (docResponse.statusCode == 200) {
          print('Документ успішно збережено!');
        } else {
          print('Помилка при збереженні документа: ${docResponse.statusCode}');
        }
=======
      if (checkIfEmptyExist(ttnParams)) {
        //throw Exception('There is empty field!');
        print('There is empty field!');
>>>>>>> 9c836b5e2f92e87df8d70832726aa8db62c6f1d3:lib/feature/ttn_temp_recreated/cubit/ttn_print_cubit.dart
      } else {
        String requestBody = jsonEncode({'ttn_data': ttnParams});

        var response = await http.post(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Authorization': basicAuth,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: requestBody,
        );
        if (response.statusCode == 200) {
          print('Дані успішно збережено!');
        } else {
          print('Помилка при збереженні даних: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Помилка під час виконання запиту: $e');
    }
  }


  Future<void> printBarcodeLabel(TtnData ttnData) async {
    if (ttnData.ttnRef.isEmpty || ttnData.apiKey.isEmpty) {
      emit(state.copyWith(
        ttnParams: [],
        ttnData: TtnData.empty,
        status: TtnPrintStatus.failure,
        errorMassage: 'Дані не отримано',
        action: MyAction.waiting,
      ));
      return;
    }

    String apiUrl =
        'https://my.novaposhta.ua/orders/printMarking100x100/orders[]/${ttnData.ttnRef}/type/pdf/apiKey/${ttnData.apiKey}/zebra';

    final response = await http.get(Uri.parse(apiUrl));
    final prefs = await SharedPreferences.getInstance();

    if (response.statusCode == 200) {
      final contentType = response.headers['content-type'];
      if (contentType != null && contentType == 'application/pdf') {
        Uint8List pdfData = response.bodyBytes;

        String? printerHost = prefs.getString('printer_host');
        if (printerHost != null) {
          bool isPrinterAvailable =
              await checkPrinterAvailability(printerHost, 9100);
          if (isPrinterAvailable) {
            await sendToPrinter(printerHost, 9100, pdfData);
            emit(state.copyWith(
              ttnParams: [],
              ttnData: TtnData.empty,
              status: TtnPrintStatus.success,
              action: MyAction.printing,
            ));
          } else {
            emit(state.copyWith(
              ttnParams: [],
              ttnData: TtnData.empty,
              status: TtnPrintStatus.failure,
              action: MyAction.waiting,
              errorMassage: 'Принтер недоступний за вказаною IP-адресою',
            ));
          }
        } else {
          emit(state.copyWith(
            ttnData: TtnData.empty,
            ttnParams: [],
            status: TtnPrintStatus.failure,
            action: MyAction.waiting,
            errorMassage: 'Адресу принтера не вказано',
          ));
          return;
        }
      } else {
        emit(state.copyWith(
          ttnParams: [],
          ttnData: TtnData.empty,
          action: MyAction.waiting,
          status: TtnPrintStatus.failure,
          errorMassage: 'Відповідь не є PDF-документом',
        ));
        return;
      }
    } else {
      emit(state.copyWith(
        ttnParams: [],
        ttnData: TtnData.empty,
        action: MyAction.waiting,
        status: TtnPrintStatus.failure,
        errorMassage: 'Не вдалося надрукувати етикетку',
      ));
      return;
    }
  }

  Future<void> sendToPrinter(String printerIp, int port, Uint8List data) async {
    try {
      final socket = await Socket.connect(printerIp, port);
      socket.add(data);
      await socket.flush();
      await socket.close();
      emit(state.copyWith(
        ttnData: TtnData.empty,
        ttnParams: [],
        status: TtnPrintStatus.success,
        action: MyAction.printing,
        errorMassage: 'Завдання на друк успішно надіслано',
      ));
    } catch (e) {
      emit(state.copyWith(
        ttnParams: [],
        ttnData: TtnData.empty,
        status: TtnPrintStatus.failure,
        errorMassage: 'Не вдалося надіслати завдання на друк',
        action: MyAction.waiting,
      ));
      return;
    }
  }

  void clear() {
    emit(state.copyWith(
      ttnData: TtnData.empty,
      ttnParams: [],
      status: TtnPrintStatus.initial,
      action: MyAction.waiting,
      errorMassage: '',
    ));
  }

  bool checkIfEmptyExist(List<TtnParams> ttnParams) {
    for (var item in ttnParams) {
      if (item.notEmpty) {
        continue;
      } else {
        emit(state.copyWith(
          errorMassage: 'Пусте поле!!!',
        ));
        return true;
      }
    }
    return false;
  }
}

Future<bool> checkPrinterAvailability(String printerIp, int port) async {
  try {
    final socket = await Socket.connect(printerIp, port,
        timeout: const Duration(seconds: 5));
    socket.destroy();
    return true;
  } catch (e) {
    return false;
  }
}
