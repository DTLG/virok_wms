import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/feature/ttn_temp_recreated/models/ttn_data.dart';
import 'package:virok_wms/feature/ttn_temp_recreated/models/ttn_params.dart';

part 'ttn_print_state.dart';

class TtnPrintCubit extends Cubit<TtnPrintState> {
  TtnPrintCubit() : super(TtnPrintState());

  Future<void> getTtnData(String query, String value) async {
    try {
      if (value.isNotEmpty) {
        emit(state.copyWith(
          ttnData: TtnData.empty,
          ttnParams: [],
          status: TtnPrintStatus.loading,
          action: MyAction.fetchingInfo,
        ));
        final ttnData = await fetchTtnData(value);
        final ttnParams = await fetchTtnParams(value);

        emit(state.copyWith(
            status: TtnPrintStatus.success,
            ttnData: ttnData,
            ttnParams: ttnParams,
            errorMassage: 'Дані отримано!'));
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
    value = '111170202405';

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

    if (response.statusCode == 200) {
      List<dynamic> jsonData =
          jsonDecode(utf8.decode(response.bodyBytes))["ttn_data"];

      List<TtnParams> ttnParamsList = [];
      for (var item in jsonData) {
        TtnParams ttnParams = TtnParams.fromJson(item);
        ttnParamsList.add(ttnParams);
      }
      return ttnParamsList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<TtnData> fetchTtnData(String value) async {
    final prefs = await SharedPreferences.getInstance();
    String api = prefs.getString('api')!;
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
      final updatedParams = state.ttnParams ;
      updatedParams.remove(paramToRemove);
      emit(state.copyWith(ttnParams: updatedParams));
    }

  Future<void> saveTtnParams(
      String docBarcode, List<TtnParams> ttnParams) async {
    // Формування URL для запиту
    final prefs = await SharedPreferences.getInstance();
    docBarcode = '111170202405';

    String apiUrl =
        'http://192.168.2.50:81/virok_wms/hs/New/save_ttn_params?DocBarcode=$docBarcode';

    String username = prefs.getString('zone')!;
    String password = prefs.getString('password')!;

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    try {
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

    final String apiUrl =
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
}

Future<bool> checkPrinterAvailability(String printerIp, int port) async {
  try {
    final socket =
        await Socket.connect(printerIp, port, timeout: Duration(seconds: 5));
    socket.destroy();
    return true;
  } catch (e) {
    return false;
  }
}
