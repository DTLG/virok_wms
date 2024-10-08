import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart';
import 'package:virok_wms/feature/epicenter_page/client/api_client.dart';
import 'package:virok_wms/feature/epicenter_page/model/label_info.dart';
import 'package:virok_wms/feature/epicenter_page/model/nom.dart';
import 'package:virok_wms/feature/moving_defective_page/widget/toast.dart';
import 'package:virok_wms/feature/storage_operation/placement_writing_off/placement_goods/ui/ui.dart';

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

  Future<void> finishDoc(
      BuildContext context, String guid, int placeCount) async {
    final client = ApiClient();
    try {
      final res = await client.finishDoc(guid, placeCount);
      showToast(res);
      if (res != 'OK') {
        Navigator.of(context).pop(); // Закриваємо діалог
        Navigator.of(context).pop(true); // Закриваємо екран
      }
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

  Nom? getIndexByBarcode(String barcode) {
    final noms = state.noms;
    for (int i = 0; i < noms.length; i++) {
      var barcodes = noms[i].barcodes;

      for (var b in barcodes) {
        if (b.barcode == barcode) {
          return noms[i];
        }
      }
    }
    return null;
  }

  void setJumpIndex(int itemIndex) {
    emit(state.copyWith(jumpIndex: itemIndex));
  }

  Future<LabelInfo?> getLabelInfo(String guid) async {
    final client = ApiClient();
    try {
      return await client.getLabelInfo(guid);
    } catch (error) {
      emit(state.copyWith(
          errorMassage: "Помилка при отриманні даних: $error",
          status: EpicenterDataStatus.failure));
    }
  }
}
