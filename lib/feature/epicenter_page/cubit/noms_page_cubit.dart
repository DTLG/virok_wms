import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/epicenter_page/client/api_client.dart';
import 'package:virok_wms/feature/epicenter_page/model/nom.dart';
import 'package:virok_wms/feature/moving_defective_page/widget/toast.dart';

part 'noms_page_state.dart';

class NomsPageCubit extends Cubit<EpicenterDataState> {
  NomsPageCubit() : super(EpicenterDataState());

  Future<void> getNoms(String guid) async {
    final client = ApiClient();
    try {
      emit(state.copyWith(status: EpicenterDataStatus.loading));
      final noms = await client.getNoms(guid);
      emit(state.copyWith(noms: noms, status: EpicenterDataStatus.success));
    } catch (error) {
      emit(state.copyWith(
          errorMassage: "Помилка при отриманні даних: $error",
          status: EpicenterDataStatus.failure));
    }
  }

  Future<void> finishDoc(String guid, int placeCount) async {
    final client = ApiClient();
    try {
      final res = await client.finishDoc(guid, placeCount);
      showToast(res);
      emit(state.copyWith(status: EpicenterDataStatus.success));
    } catch (error) {
      emit(state.copyWith(
          errorMassage: "Помилка при завершенні документа: $error",
          status: EpicenterDataStatus.failure));
    }
  }

  Future<void> docScan(String guid, String barcode, int count) async {
    emit(state.copyWith(status: EpicenterDataStatus.loading));
    final client = ApiClient();

    // Call the checkNumber function to validate the barcode
    final error = checkNumber(barcode);
    if (error != null) {
      emit(state.copyWith(
          errorMassage: error, status: EpicenterDataStatus.notFound));
      return;
    }

    try {
      final noms = await client.docScan(guid, barcode, count);
      emit(state.copyWith(noms: noms, status: EpicenterDataStatus.success));
    } catch (error) {
      emit(state.copyWith(
          errorMassage: "Помилка при скануванні документа: $error",
          status: EpicenterDataStatus.failure));
    }
  }

  String? checkNumber(String barcode) {
    // Iterate over the noms to find the matching barcode
    for (var nom in state.noms) {
      for (var nomBarcode in nom.barcodes) {
        if (nomBarcode.barcode == barcode) {
          // Check if the count_scanned is less than or equal to count_need
          if (nom.countScanned >= nom.countNeed) {
            return "Помилка: Кількість відсканованих більше за потрібну.";
          } else {
            return null; // No error, barcode is valid
          }
        }
      }
    }

    // If barcode is not found, return an error
    return "Помилка: Штрихкод не знайдено.";
  }
}
