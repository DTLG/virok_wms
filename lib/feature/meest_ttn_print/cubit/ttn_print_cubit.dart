import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'ttn_print_state.dart';

class TtnPrintCubit extends Cubit<TtnPrintState> {
  TtnPrintCubit() : super(const TtnPrintState());

  
  Future<void> getParcelID(String parcelId) async {
    String apiUrl = 'https://api.meest.com/v3.0/openAPI/getParcel/$parcelId/parcelID';

    Map<String, String> headers = {
      'Key': '5c3749e3598ef423b092b7daf8405206',
      'token': '5d614ef5c71b6172c87460e915b12c31',
    };

    try {
      var response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        // Decode the response body as UTF-8
        String responseBody = utf8.decode(response.bodyBytes);

        Map<String, dynamic> responseData = jsonDecode(responseBody);

        // Extract phone, name, and full address from responseData
        String phone = responseData['result']['receiver']['phone'];
        String name = responseData['result']['receiver']['name'];
        String address = '${responseData['result']['receiver']['branchDescr']}'
            '${responseData['result']['receiver']['flat'] != '' ? ', кв. ${responseData['result']['receiver']['flat']}' : ''}';

        emit(state.copyWith(
          action: MyAction.fetchingInfo,
          printValue: responseData['result']['parcelID'],
          receiverInfo: {
            'phone': phone,
            'name': name,
            'address': address,
          },
          status: TtnPrintStatus.success,
        ));
      } else {
        emit(state.copyWith(
            status: TtnPrintStatus.failure,
            errorMassage: 'Failed to get parcel details. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      emit(state.copyWith(
          status: TtnPrintStatus.failure,
          errorMassage: 'Error getting parcel details: $e'));
    }
  }


  Future<void> printSticker(String printValue) async {
    final prefs = await SharedPreferences.getInstance();
    String? printerHost = prefs.getString('printer_host');
    final String apiUrl =
        'https://api.meest.com/v3.0/openAPI/print/sticker100/$printValue';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'];
        if (contentType != null && contentType == 'application/pdf') {
          Uint8List pdfData = response.bodyBytes;
          await sendToPrinter(printerHost!, 9100, pdfData);
          emit(state.copyWith(
            printValue: '',
          ));
        } else {
          emit(state.copyWith(
            status: TtnPrintStatus.failure,
            action: MyAction.printing,
            errorMassage: 'Response is not a PDF document',
          ));
        }
      } else {
        emit(state.copyWith(
          status: TtnPrintStatus.failure,
          action: MyAction.printing,
          errorMassage: 'Failed to print sticker',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: TtnPrintStatus.failure,
        action: MyAction.printing,
        errorMassage: 'Error during connection: $e',
      ));
    }
  }


  Future<void> sendToPrinter(String printerIp, int port, Uint8List data) async {
    try {
      final socket = await Socket.connect(printerIp, port);
      socket.add(data);
      await socket.flush();
      await socket.close();
      emit(state.copyWith(
        status: TtnPrintStatus.success,
        action: MyAction.printing,
        errorMassage: 'Завдання на друк успішно надіслано',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TtnPrintStatus.failure,
        errorMassage: 'Не вдалося надіслати завдання на друк',
        action: MyAction.waiting,
      ));
      return;
    }
  }
}
